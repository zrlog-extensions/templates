package com.zrlog.themes;

import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.*;
import java.time.Duration;
import java.util.*;

final class ThemeDescriptor {
    static JsonObject validate(JsonObject config) {
        ThemeFiles.require(config.get("schemaVersion").getAsInt() == 1, "Unsupported theme descriptor version");
        String id = config.get("id").getAsString();
        ThemeFiles.require(ThemeFiles.ID.matcher(id).matches(), "Invalid theme ID: " + id);
        for (String field : List.of("name", "author", "description", "preview", "repository", "engine", "sourceDirectory", "createdDate")) {
            ThemeFiles.require(config.has(field) && !config.get(field).getAsString().isBlank(), "Missing theme descriptor field: " + field);
        }
        String engine = config.get("engine").getAsString();
        ThemeFiles.require(Set.of("freemarker", "jsp").contains(engine), "Unsupported theme engine");
        if (config.has("testedRuntime") && !config.get("testedRuntime").isJsonNull()) {
            ThemeFiles.require(!config.get("testedRuntime").getAsString().isBlank(), "testedRuntime must be a verified version or null");
        }
        https(config.get("repository").getAsString());
        https(config.get("preview").getAsString());
        var distribution = config.getAsJsonObject("distribution");
        String mode = distribution.get("mode").getAsString();
        ThemeFiles.require(Set.of("shared", "release").contains(mode), "distribution.mode must be shared or release");
        if (mode.equals("shared")) {
            ThemeFiles.require(engine.equals("freemarker"), "Shared build and preview support FreeMarker only; JSP themes maintain their own releases");
            String target = distribution.get("target").getAsString();
            ThemeFiles.require(Set.of("github-release", "s3").contains(target), "Unsupported shared publication target");
            if (target.equals("s3")) https(distribution.get("publicBaseUrl").getAsString());
        }
        if (config.has("historicalRelease") && !config.get("historicalRelease").isJsonNull()) {
            var historical = config.getAsJsonObject("historicalRelease");
            https(historical.get("url").getAsString());
            ThemeFiles.require(!historical.get("tag").getAsString().isBlank(), "Missing historical release tag");
        }
        if (config.has("latestRelease") && !config.get("latestRelease").isJsonNull()) {
            var release = config.getAsJsonObject("latestRelease");
            https(release.get("url").getAsString());
            ThemeFiles.require(release.get("sha256").getAsString().matches("[0-9a-f]{64}"), "Invalid release SHA-256");
            ThemeFiles.require(!release.get("tag").getAsString().isBlank(), "Missing release tag");
        }
        return config;
    }

    static Path source(Path repository, JsonObject config) {
        Path root = repository.toAbsolutePath().normalize();
        Path source = root.resolve(config.get("sourceDirectory").getAsString()).normalize();
        ThemeFiles.require(source.startsWith(root), "sourceDirectory must stay inside the theme repository");
        Path cursor = source;
        while (cursor != null && cursor.startsWith(root)) {
            ThemeFiles.require(!Files.isSymbolicLink(cursor), "sourceDirectory must not traverse symlinks");
            cursor = cursor.getParent();
        }
        return source;
    }

    static Path build(Path repository, Path outputDirectory) throws Exception {
        JsonObject config = validate(ThemeFiles.json(repository.resolve("theme.json")));
        ThemeFiles.require(config.get("engine").getAsString().equals("freemarker"), "Shared packaging supports FreeMarker only");
        return ThemeFiles.pack(source(repository, config), outputDirectory.resolve(config.get("id").getAsString() + ".zip"));
    }

    static JsonObject release(JsonObject config, Path archive, String tag, String url) throws Exception {
        validate(config);
        ThemeFiles.require(tag.matches("v[0-9][A-Za-z0-9._-]*"), "Release tag must be v<version>");
        ThemeFiles.require(archive.getFileName().toString().equals(config.get("id").getAsString() + ".zip"), "Release package ID mismatch");
        try (var zip = new java.util.zip.ZipFile(archive.toFile())) {
            var entry = zip.getEntry("template.properties");
            ThemeFiles.require(entry != null, "Release archive has no template.properties");
            Properties metadata = new Properties();
            try (var reader = new java.io.InputStreamReader(zip.getInputStream(entry), java.nio.charset.StandardCharsets.UTF_8)) { metadata.load(reader); }
            ThemeFiles.require(tag.substring(1).equals(metadata.getProperty("version")), "Tag must match template.properties version");
        }
        https(url);
        JsonObject result = config.deepCopy();
        JsonObject release = new JsonObject();
        release.addProperty("tag", tag);
        release.addProperty("url", url);
        release.addProperty("sha256", ThemeFiles.sha256(archive));
        result.add("latestRelease", release);
        return result;
    }

    static void syncCatalog(Path root, Path local) throws Exception {
        JsonObject catalog = ThemeFiles.json(root.resolve("catalog.json"));
        var updated = new HashMap<String, JsonObject>();
        JsonObject localConfig = local == null ? null : validate(ThemeFiles.json(local));
        var client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).followRedirects(HttpClient.Redirect.NORMAL).build();
        for (var element : ThemeFiles.json(root.resolve("catalog.sources.json")).getAsJsonArray("themes")) {
            var source = element.getAsJsonObject();
            String id = source.get("id").getAsString();
            if (localConfig != null && !id.equals(localConfig.get("id").getAsString())) continue;
            URI uri = https(source.get("configUrl").getAsString());
            byte[] bytes;
            if (localConfig != null) bytes = Files.readAllBytes(local);
            else {
                // Fetch only the declared descriptor. Never clone a theme or download its ZIP here.
                var response = client.send(HttpRequest.newBuilder(uri).timeout(Duration.ofSeconds(30)).build(), HttpResponse.BodyHandlers.ofInputStream());
                try (var input = response.body()) {
                    ThemeFiles.require(response.statusCode() == 200, "Descriptor download failed: " + uri + " (" + response.statusCode() + ")");
                    bytes = input.readNBytes(1024 * 1024 + 1);
                }
            }
            ThemeFiles.require(bytes.length <= 1024 * 1024, "Descriptor exceeds 1 MiB");
            var descriptor = validate(JsonParser.parseString(new String(bytes, java.nio.charset.StandardCharsets.UTF_8)).getAsJsonObject());
            ThemeFiles.require(id.equals(descriptor.get("id").getAsString()), "Descriptor ID mismatch: " + id);
            var index = descriptor.deepCopy();
            index.remove("sourceDirectory");
            index.addProperty("status", "independent");
            index.remove("marketplaceId");
            if (source.has("marketplaceId") && !source.get("marketplaceId").isJsonNull()) index.add("marketplaceId", source.get("marketplaceId"));
            index.addProperty("configUrl", uri.toString());
            index.addProperty("configSha256", HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(bytes)));
            updated.put(id, index);
        }
        ThemeFiles.require(!updated.isEmpty(), "No configured theme descriptor matched");
        var entries = new com.google.gson.JsonArray();
        for (var element : catalog.getAsJsonArray("themes")) {
            String id = element.getAsJsonObject().get("id").getAsString();
            entries.add(updated.containsKey(id) ? updated.remove(id) : element);
        }
        updated.values().stream().sorted(Comparator.comparing(e -> e.get("id").getAsString())).forEach(entries::add);
        catalog.add("themes", entries);
        var marketplaceIds = new HashSet<Long>();
        for (var element : entries) {
            var entry = element.getAsJsonObject();
            if (entry.has("marketplaceId")) ThemeFiles.require(marketplaceIds.add(entry.get("marketplaceId").getAsLong()), "Duplicate marketplace ID");
        }
        write(root.resolve("catalog.json"), catalog);
        System.out.println("Catalog refreshed from theme descriptors only");
    }

    static URI https(String value) {
        URI uri = URI.create(value);
        ThemeFiles.require("https".equals(uri.getScheme()) && uri.getHost() != null && uri.getUserInfo() == null, "Expected HTTPS URL: " + value);
        return uri;
    }

    static void write(Path path, JsonObject object) throws Exception {
        Path parent = path.toAbsolutePath().getParent();
        Files.createDirectories(parent);
        Path temporary = Files.createTempFile(parent, ".descriptor-", ".json");
        try {
            Files.writeString(temporary, new GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create().toJson(object) + "\n");
            Files.move(temporary, path, StandardCopyOption.REPLACE_EXISTING);
        } finally { Files.deleteIfExists(temporary); }
    }
}
