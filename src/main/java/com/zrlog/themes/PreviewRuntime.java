package com.zrlog.themes;

import com.google.gson.JsonObject;

import java.net.URI;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.*;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.TimeUnit;

final class PreviewRuntime {
    static Path download(Path root) throws Exception {
        JsonObject lock = ThemeFiles.json(root.resolve("preview/runtime.lock.json"));
        URI url = URI.create(lock.get("url").getAsString());
        ThemeFiles.require("https".equals(url.getScheme()), "Runtime URL must use HTTPS");
        Path cache = root.resolve(".cache");
        Files.createDirectories(cache);
        Path archive = cache.resolve(Path.of(url.getPath()).getFileName());
        String expected = lock.get("sha256").getAsString();
        if (!Files.exists(archive)) {
            Path temporary = Files.createTempFile(cache, "download-", ".zip");
            try {
                var client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(20)).followRedirects(HttpClient.Redirect.NORMAL).build();
                var request = HttpRequest.newBuilder(url).timeout(Duration.ofMinutes(3)).header("User-Agent", "ZrLog-theme-toolkit/1").build();
                var response = client.send(request, HttpResponse.BodyHandlers.ofFile(temporary));
                ThemeFiles.require(response.statusCode() == 200, "Runtime download failed: HTTP " + response.statusCode());
                ThemeFiles.require(expected.equals(ThemeFiles.sha256(temporary)), "Runtime SHA-256 mismatch");
                Files.move(temporary, archive, StandardCopyOption.REPLACE_EXISTING);
            } finally { Files.deleteIfExists(temporary); }
        }
        ThemeFiles.require(expected.equals(ThemeFiles.sha256(archive)), "Runtime SHA-256 mismatch; remove " + archive + " and retry");
        return archive;
    }

    static int run(Path root, Path source, int port, boolean empty, boolean comments, Path settings, String themeId) throws Exception {
        ThemeFiles.require(port >= 1024 && port <= 65535, "Preview port must be between 1024 and 65535");
        try (ServerSocket probe = new ServerSocket()) { probe.bind(new InetSocketAddress("127.0.0.1", port)); }
        source = source.toAbsolutePath().normalize();
        boolean zipped = source.toString().endsWith(".zip");
        String id = themeId == null ? source.getFileName().toString().replaceFirst("\\.zip$", "") : themeId;
        ThemeFiles.require(ThemeFiles.ID.matcher(id).matches(), "Theme directory or ZIP must be named template-<id>");
        Path archive = download(root);
        Files.createDirectories(root.resolve(".preview"));
        Path run = Files.createTempDirectory(root.resolve(".preview"), "run-");
        Process process = null;
        Thread shutdown = null;
        Runnable cleanup = null;
        try {
            ThemeFiles.extract(archive, run.resolve("release"));
            Path site = Files.createDirectory(run.resolve("site"));
            Path themeSource = source;
            if (zipped) {
                themeSource = run.resolve("theme-check");
                ThemeFiles.extract(source, themeSource);
            }
            ThemeFiles.check(themeSource);
            JsonObject values = settings == null ? new JsonObject() : ThemeFiles.json(settings);
            Path definition = themeSource.resolve("setting/config-form.json");
            JsonObject definitions = Files.exists(definition) ? ThemeFiles.json(definition) : new JsonObject();
            for (String key : values.keySet()) ThemeFiles.require(definitions.has(key), "Unknown preview setting: " + key);
            Path settingsFile = run.resolve("settings.json");
            Files.writeString(settingsFile, values.toString());
            Path destination = site.resolve("static/include/templates").resolve(id);
            Map<Path, String> synced = zipped ? Map.of() : ThemeFiles.sync(source, destination, Map.of());
            ThemeFiles.copyTree(root.resolve("preview/fixtures/assets"), site.resolve("static/attached"));
            String executable = Path.of(System.getProperty("java.home"), "bin", System.getProperty("os.name").startsWith("Windows") ? "java.exe" : "java").toString();
            List<String> command = new ArrayList<>(List.of(executable, "-cp", run.resolve("release/lib/*").toString(),
                    root.resolve("preview/PreviewApplication.java").toString(), site.toString(), root.resolve("preview/fixtures").toString(),
                    id, Integer.toString(port), Boolean.toString(empty), Boolean.toString(comments), settingsFile.toString()));
            if (zipped) command.add(source.toString());
            System.out.println("ZrLog " + ThemeFiles.json(root.resolve("preview/runtime.lock.json")).get("version").getAsString() + "; source=" + source + "; runtime=" + site);
            process = new ProcessBuilder(command).directory(site.toFile()).inheritIO().start();
            Process child = process;
            cleanup = new Runnable() {
                private boolean closed;
                @Override public synchronized void run() {
                    if (closed) return;
                    closed = true;
                    stop(child);
                    try { ThemeFiles.deleteTree(run); }
                    catch (Exception error) { System.err.println("Cleanup: " + error.getMessage()); }
                }
            };
            shutdown = new Thread(cleanup, "preview-shutdown");
            Runtime.getRuntime().addShutdownHook(shutdown);
            while (!process.waitFor(500, TimeUnit.MILLISECONDS)) {
                if (!zipped) {
                    try { synced = ThemeFiles.sync(source, destination, synced); }
                    catch (Exception error) { System.err.println("Preview sync: " + error.getMessage()); }
                }
            }
            return process.exitValue();
        } finally {
            if (shutdown != null) {
                try { Runtime.getRuntime().removeShutdownHook(shutdown); }
                catch (IllegalStateException ignored) { /* Shutdown hook owns cleanup during SIGINT/SIGTERM. */ }
            }
            if (cleanup != null) cleanup.run();
            else {
                if (process != null) stop(process);
                ThemeFiles.deleteTree(run);
            }
        }
    }

    private static void stop(Process process) {
        if (!process.isAlive()) return;
        process.destroy();
        try {
            if (!process.waitFor(10, TimeUnit.SECONDS)) process.destroyForcibly().waitFor();
        } catch (InterruptedException error) {
            process.destroyForcibly();
            Thread.currentThread().interrupt();
        }
    }
}
