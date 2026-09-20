package com.zrlog.themes;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.TimeZone;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import static org.junit.jupiter.api.Assertions.*;

class ThemeFilesTest {
    @TempDir Path temp;
    Path source;

    @BeforeEach void prepare() throws Exception {
        source = temp.resolve("template-example");
        ThemeFiles.copyTree(Path.of("starter"), source);
    }

    @Test void packagingIsReproducibleAcrossTimeZonesAndExcludesDevelopmentAndSecrets() throws Exception {
        Files.writeString(source.resolve(".env"), "secret=fixture");
        Files.writeString(source.resolve("css/private.key"), "fixture");
        Files.writeString(source.resolve("css/credentials.js"), "fixture");
        Files.writeString(source.resolve("css/site.db"), "fixture");
        Files.createDirectory(source.resolve(".git"));
        Files.writeString(source.resolve(".git/config"), "fixture");
        Path first = ThemeFiles.pack(source, temp.resolve("one/template-example.zip"));
        TimeZone previous = TimeZone.getDefault();
        Path second;
        try {
            TimeZone.setDefault(TimeZone.getTimeZone("America/New_York"));
            second = ThemeFiles.pack(source, temp.resolve("two/template-example.zip"));
        } finally { TimeZone.setDefault(previous); }
        assertArrayEquals(Files.readAllBytes(first), Files.readAllBytes(second));
        try (ZipFile zip = new ZipFile(first.toFile())) {
            assertNotNull(zip.getEntry("index.ftl"));
            assertNotNull(zip.getEntry("css/style.css"));
            for (String excluded : new String[]{"README.md", ".env", ".git/config", "css/private.key", "css/credentials.js", "css/site.db"}) assertNull(zip.getEntry(excluded), excluded);
        }
    }

    @Test void missingAndEscapingIncludesFail() throws Exception {
        for (String include : new String[]{"missing.ftl", "../outside.ftl"}) {
            Files.writeString(source.resolve("index.ftl"), "<#include \"" + include + "\">");
            assertThrows(IllegalArgumentException.class, () -> ThemeFiles.check(source));
        }
    }

    @Test void rejectsTheOldArrayConfigFormat() throws Exception {
        Files.writeString(source.resolve("setting/config-form.json"), "[{\"name\":\"introText\"}]");
        assertThrows(IllegalArgumentException.class, () -> ThemeFiles.check(source));
    }

    @Test void refusesSymlinkInPackageAndPreview() throws Exception {
        Path outside = Files.writeString(temp.resolve("outside.css"), "fixture");
        Files.createSymbolicLink(source.resolve("css/outside.css"), outside);
        assertThrows(IllegalArgumentException.class, () -> ThemeFiles.check(source));
    }

    @Test void validatesWholeZipBeforeExtractingTraversal() throws Exception {
        Path archive = temp.resolve("malicious.zip");
        try (ZipOutputStream zip = new ZipOutputStream(Files.newOutputStream(archive))) {
            for (String name : new String[]{"safe.txt", "../outside.txt"}) {
                zip.putNextEntry(new ZipEntry(name)); zip.write("fixture".getBytes()); zip.closeEntry();
            }
        }
        assertThrows(IllegalArgumentException.class, () -> ThemeFiles.extract(archive, temp.resolve("unpacked")));
        assertFalse(Files.exists(temp.resolve("unpacked/safe.txt")));
        assertFalse(Files.exists(temp.resolve("outside.txt")));
    }

    @Test void refusesCorruptRuntimeCacheWithoutDownloading() throws Exception {
        Path cache = Files.createDirectory(temp.resolve(".cache"));
        Files.createDirectory(temp.resolve("preview"));
        Files.writeString(temp.resolve("preview/runtime.lock.json"), "{\"url\":\"https://example.invalid/runtime.zip\",\"sha256\":\"bad\"}");
        Files.writeString(cache.resolve("runtime.zip"), "corrupt");
        assertThrows(IllegalArgumentException.class, () -> PreviewRuntime.download(temp));
    }

    @Test void previewSyncHandlesAddChangeAndRemove() throws Exception {
        Path destination = temp.resolve("preview");
        var state = ThemeFiles.sync(source, destination, Map.of());
        Path added = Files.writeString(source.resolve("css/new.css"), "body { color: red }");
        state = ThemeFiles.sync(source, destination, state);
        assertEquals(Files.readString(added), Files.readString(destination.resolve("css/new.css")));
        Files.writeString(added, "body { color: purple }");
        state = ThemeFiles.sync(source, destination, state);
        assertEquals(Files.readString(added), Files.readString(destination.resolve("css/new.css")));
        Files.delete(added);
        ThemeFiles.sync(source, destination, state);
        assertFalse(Files.exists(destination.resolve("css/new.css")));
    }
}
