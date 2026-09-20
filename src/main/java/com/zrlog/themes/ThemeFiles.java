package com.zrlog.themes;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.IOException;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

final class ThemeFiles {
    static final Pattern ID = Pattern.compile("template-[a-z0-9]+(?:-[a-z0-9]+)*");
    private static final Set<String> EXCLUDED = Set.of(".git", ".svn", ".hg", "node_modules", "dist", "target", "docs", "examples", "bin", "src");
    private static final Set<String> ASSETS = Set.of("css", "js", "mjs", "png", "jpg", "jpeg", "gif", "bmp", "webp", "avif", "svg", "ico", "woff", "woff2", "ttf", "otf", "eot");
    private static final Pattern INCLUDE = Pattern.compile("<#(?:include|import)\\s+[\"']([^\"']+)");
    private static final long MAX_ARCHIVE_SIZE = 512L * 1024 * 1024;

    record Theme(Properties metadata, List<Path> files) { }

    static JsonObject json(Path path) throws IOException {
        try (Reader reader = Files.newBufferedReader(path)) {
            var element = JsonParser.parseReader(reader);
            require(element.isJsonObject(), path + " must be a JSON object");
            return element.getAsJsonObject();
        }
    }

    static void require(boolean condition, String message) {
        if (!condition) throw new IllegalArgumentException(message);
    }

    static Theme files(Path source) throws IOException {
        require(Files.isDirectory(source, LinkOption.NOFOLLOW_LINKS), "Theme source must be a regular directory");
        Path info = source.resolve("template.properties");
        require(!Files.isSymbolicLink(info), "Metadata must not be a symlink");
        Properties meta = new Properties();
        try (Reader reader = Files.newBufferedReader(info, StandardCharsets.UTF_8)) { meta.load(reader); }
        for (String key : List.of("author", "name", "url", "digest", "version", "staticResource")) {
            require(!meta.getProperty(key, "").isBlank(), "Missing theme metadata: " + key);
        }
        Set<String> directories = new HashSet<>();
        for (String name : meta.getProperty("staticResource").split(",", -1)) {
            require(name.matches("[A-Za-z0-9_-]+") && !EXCLUDED.contains(name), "Invalid staticResource directory: " + name);
            require(Files.isDirectory(source.resolve(name)), "Missing staticResource directory: " + name);
            directories.add(name);
        }
        List<Path> files = new ArrayList<>();
        Files.walkFileTree(source, new SimpleFileVisitor<>() {
            @Override public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) {
                return !dir.equals(source) && excluded(dir.getFileName().toString()) ? FileVisitResult.SKIP_SUBTREE : FileVisitResult.CONTINUE;
            }
            @Override public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
                String name = file.getFileName().toString();
                if (excluded(name)) return FileVisitResult.CONTINUE;
                require(!attrs.isSymbolicLink(), "Symlinks are not allowed: " + file);
                Path relative = source.relativize(file);
                String entry = entryName(relative);
                String extension = name.contains(".") ? name.substring(name.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT) : "";
                boolean allowed = entry.equals("template.properties") || entry.equals("setting/config-form.json") || extension.equals("ftl")
                        || relative.getName(0).toString().equals("language") && extension.equals("properties")
                        || directories.contains(relative.getName(0).toString()) && ASSETS.contains(extension);
                if (allowed && attrs.isRegularFile()) files.add(relative);
                return FileVisitResult.CONTINUE;
            }
        });
        files.sort(Comparator.comparing(ThemeFiles::entryName));
        return new Theme(meta, files);
    }

    private static boolean excluded(String name) {
        String lower = name.toLowerCase(Locale.ROOT);
        return name.startsWith(".") || EXCLUDED.contains(name) || lower.matches("(?:credentials?|secrets?|passwords?)(?:\\..*)?");
    }

    static Theme check(Path source) throws IOException {
        Theme theme = files(source);
        Set<String> available = new HashSet<>();
        theme.files.forEach(p -> available.add(entryName(p)));
        for (String name : List.of("index.ftl", "page.ftl", "detail.ftl", "404.ftl", "language/i18n_zh_CN.properties", "language/i18n_en_US.properties")) {
            require(available.contains(name), "Missing required theme file: " + name);
        }
        for (String name : theme.metadata.getProperty("previewImages", "").split(",")) {
            require(name.isEmpty() || available.contains(name), "Preview image is missing or excluded: " + name);
        }
        Path config = source.resolve("setting/config-form.json");
        if (Files.exists(config)) {
            for (var field : json(config).entrySet()) {
                require(field.getValue().isJsonObject(), "Invalid setting: " + field.getKey());
                JsonObject value = field.getValue().getAsJsonObject();
                require(value.has("label") && value.has("type"), "Setting needs label and type: " + field.getKey());
                require(!value.has("htmlElementType") || Set.of("input", "textarea", "large-textarea", "switch", "colorPicker")
                        .contains(value.get("htmlElementType").getAsString()), "Unsupported setting control: " + field.getKey());
            }
        }
        for (Path path : theme.files) {
            if (!path.toString().endsWith(".ftl")) continue;
            var matcher = INCLUDE.matcher(Files.readString(source.resolve(path)));
            while (matcher.find()) {
                String include = matcher.group(1);
                if (include.contains("${")) continue;
                Path target = include.startsWith("/") ? Path.of(include.substring(1)) : path.resolveSibling(include);
                String normalized = entryName(target.normalize());
                require(!target.isAbsolute() && !normalized.startsWith("../") && available.contains(normalized), "Missing packaged include: " + path + ": " + include);
            }
        }
        return theme;
    }

    static Path pack(Path source, Path output) throws Exception {
        Theme theme = check(source);
        String name = output.getFileName().toString();
        require(name.endsWith(".zip") && ID.matcher(name.substring(0, name.length() - 4)).matches(), "Output must be template-<id>.zip");
        output = output.toAbsolutePath();
        Files.createDirectories(output.getParent());
        Path temporary = Files.createTempFile(output.getParent(), ".theme-", ".zip");
        try {
            try (ZipOutputStream zip = new ZipOutputStream(Files.newOutputStream(temporary))) {
                zip.setLevel(9);
                for (Path path : theme.files) {
                    ZipEntry entry = new ZipEntry(entryName(path));
                    entry.setTimeLocal(LocalDateTime.of(2020, 1, 1, 0, 0));
                    zip.putNextEntry(entry);
                    Files.copy(source.resolve(path), zip);
                    zip.closeEntry();
                }
            }
            Files.move(temporary, output, StandardCopyOption.REPLACE_EXISTING);
        } finally { Files.deleteIfExists(temporary); }
        Files.writeString(output.resolveSibling(name + ".sha256"), sha256(output) + "  " + name + "\n");
        return output;
    }

    static String sha256(Path path) throws Exception {
        MessageDigest hash = MessageDigest.getInstance("SHA-256");
        try (var input = Files.newInputStream(path)) {
            byte[] buffer = new byte[65536];
            int read;
            while ((read = input.read(buffer)) != -1) hash.update(buffer, 0, read);
        }
        return HexFormat.of().formatHex(hash.digest());
    }

    static void extract(Path archive, Path destination) throws IOException {
        try (ZipFile zip = new ZipFile(archive.toFile())) {
            List<? extends ZipEntry> entries = Collections.list(zip.entries());
            Set<String> seen = new HashSet<>();
            long total = 0;
            // Validate the entire central directory before writing any files.
            for (ZipEntry entry : entries) {
                String name = entry.getName();
                Path path = Path.of(name);
                require(!name.contains("\\") && !name.contains(":") && !path.isAbsolute()
                        && !Arrays.asList(name.split("/")).contains("..") && seen.add(entryName(path.normalize())), "Unsafe ZIP entry: " + name);
                require(entry.getSize() >= 0 && entry.getSize() <= MAX_ARCHIVE_SIZE, "Invalid ZIP entry size");
                total += entry.getSize();
                require(total <= MAX_ARCHIVE_SIZE, "Archive exceeds 512 MiB");
            }
            long written = 0;
            byte[] buffer = new byte[65536];
            for (ZipEntry entry : entries) {
                Path target = destination.resolve(entry.getName());
                if (entry.isDirectory()) { Files.createDirectories(target); continue; }
                Files.createDirectories(target.getParent());
                try (var input = zip.getInputStream(entry); var output = Files.newOutputStream(target, StandardOpenOption.CREATE_NEW)) {
                    int read;
                    while ((read = input.read(buffer)) != -1) {
                        written += read;
                        require(written <= MAX_ARCHIVE_SIZE, "Expanded archive exceeds 512 MiB");
                        output.write(buffer, 0, read);
                    }
                }
            }
        }
    }

    static Map<Path, String> sync(Path source, Path destination, Map<Path, String> previous) throws IOException {
        Map<Path, String> current = new HashMap<>();
        for (Path path : files(source).files) {
            var stat = Files.readAttributes(source.resolve(path), BasicFileAttributes.class);
            String signature = stat.lastModifiedTime() + ":" + stat.size();
            current.put(path, signature);
            if (!signature.equals(previous.get(path))) {
                Path target = destination.resolve(path);
                Files.createDirectories(target.getParent());
                Files.copy(source.resolve(path), target, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
            }
        }
        for (Path removed : previous.keySet()) if (!current.containsKey(removed)) Files.deleteIfExists(destination.resolve(removed));
        return current;
    }

    static void copyTree(Path source, Path destination) throws IOException {
        require(!Files.exists(destination), "Destination already exists: " + destination);
        try (var paths = Files.walk(source)) {
            for (Path path : paths.toList()) {
                require(!Files.isSymbolicLink(path), "Source symlink: " + path);
                Path target = destination.resolve(source.relativize(path));
                if (Files.isDirectory(path)) Files.createDirectories(target);
                else Files.copy(path, target);
            }
        }
    }

    static void deleteTree(Path root) throws IOException {
        if (!Files.exists(root)) return;
        try (var paths = Files.walk(root)) {
            for (Path path : paths.sorted(Comparator.reverseOrder()).toList()) Files.delete(path);
        }
    }

    static String entryName(Path path) { return path.toString().replace(path.getFileSystem().getSeparator(), "/"); }
}
