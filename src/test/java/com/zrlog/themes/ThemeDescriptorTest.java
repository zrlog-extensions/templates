package com.zrlog.themes;

import com.google.gson.JsonParser;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class ThemeDescriptorTest {
    @TempDir Path temp;

    private static com.google.gson.JsonObject descriptor() {
        return JsonParser.parseString("""
                {"schemaVersion":1,"id":"template-example","name":"Example","author":"ZrLog",
                 "description":"Example theme","preview":"https://example.com/preview.jpg",
                 "repository":"https://github.com/example/template-example","engine":"freemarker",
                 "sourceDirectory":".","testedRuntime":"3.9.2","createdDate":"2026-09-21 00:00:00",
                 "distribution":{"mode":"release"},"latestRelease":null}
                """).getAsJsonObject();
    }

    @Test void releaseDescriptorBindsTagAndChecksumToActualPackage() throws Exception {
        Path source = temp.resolve("theme");
        ThemeFiles.copyTree(Path.of("starter"), source);
        Path archive = ThemeFiles.pack(source, temp.resolve("template-example.zip"));
        var result = ThemeDescriptor.release(descriptor(), archive, "v0.1.0", "https://example.com/template-example.zip");
        assertEquals(ThemeFiles.sha256(archive), result.getAsJsonObject("latestRelease").get("sha256").getAsString());
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.release(descriptor(), archive, "v9.0", "https://example.com/template-example.zip"));
    }

    @Test void sourceDirectoryCannotEscapeOrTraverseSymlink() throws Exception {
        var config = descriptor();
        config.addProperty("sourceDirectory", "../outside");
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.source(temp, config));
        Files.createSymbolicLink(temp.resolve("linked"), temp.getParent());
        config.addProperty("sourceDirectory", "linked/theme");
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.source(temp, config));
    }

    @Test void jspConfigurationDoesNotClaimSharedRuntimeSupport() throws Exception {
        var config = descriptor();
        config.addProperty("engine", "jsp");
        config.add("testedRuntime", com.google.gson.JsonNull.INSTANCE);
        assertDoesNotThrow(() -> ThemeDescriptor.validate(config));
        ThemeDescriptor.write(temp.resolve("theme.json"), config);
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.build(temp, temp.resolve("dist")));
        config.getAsJsonObject("distribution").addProperty("mode", "shared");
        config.getAsJsonObject("distribution").addProperty("target", "github-release");
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.validate(config));
    }

    @Test void unlistedThemeCannotAssignItselfAMarketplaceId() throws Exception {
        Files.writeString(temp.resolve("catalog.sources.json"), "{\"themes\":[{\"id\":\"template-example\",\"configUrl\":\"https://example.invalid/theme.json\"}]}");
        Files.writeString(temp.resolve("catalog.json"), "{\"schemaVersion\":1,\"themes\":[]}");
        var config = descriptor();
        config.addProperty("marketplaceId", 999);
        ThemeDescriptor.write(temp.resolve("theme.json"), config);
        ThemeDescriptor.syncCatalog(temp, temp.resolve("theme.json"));
        assertFalse(ThemeFiles.json(temp.resolve("catalog.json")).getAsJsonArray("themes").get(0).getAsJsonObject().has("marketplaceId"));
        Marketplace.export(temp, temp.resolve("marketplace.json"), null);
        assertEquals(0, ThemeFiles.json(temp.resolve("marketplace.json")).getAsJsonArray("themes").size());
    }

    @Test void migrationPreservesHistoricalDownloadUntilIndependentReleaseExists() throws Exception {
        var config = descriptor();
        config.addProperty("marketplaceId", 3);
        config.add("historicalRelease", JsonParser.parseString("{\"tag\":\"v1.0.0\",\"url\":\"https://example.com/old.zip\"}"));
        ThemeDescriptor.validate(config);
        var catalog = new com.google.gson.JsonObject();
        var themes = new com.google.gson.JsonArray();
        themes.add(config);
        catalog.add("themes", themes);
        ThemeDescriptor.write(temp.resolve("catalog.json"), catalog);
        Marketplace.export(temp, temp.resolve("marketplace.json"), temp.resolve("template.json"));
        var historical = ThemeFiles.json(temp.resolve("marketplace.json")).getAsJsonArray("themes").get(0).getAsJsonObject();
        assertTrue(historical.get("installable").getAsBoolean());
        assertEquals("https://example.com/old.zip", historical.get("downloadUrl").getAsString());
        assertFalse(historical.has("sha256"));
        config.add("latestRelease", JsonParser.parseString("{\"tag\":\"v2.0\",\"url\":\"https://example.com/new.zip\",\"sha256\":\"" + "a".repeat(64) + "\"}"));
        ThemeDescriptor.write(temp.resolve("catalog.json"), catalog);
        Marketplace.export(temp, temp.resolve("marketplace.json"), null);
        var current = ThemeFiles.json(temp.resolve("marketplace.json")).getAsJsonArray("themes").get(0).getAsJsonObject();
        assertEquals("https://example.com/new.zip", current.get("downloadUrl").getAsString());
        assertEquals("a".repeat(64), current.get("sha256").getAsString());
    }

    @Test void invalidDescriptorDoesNotOverwriteCatalog() throws Exception {
        Files.writeString(temp.resolve("catalog.sources.json"), "{\"themes\":[{\"id\":\"template-example\",\"marketplaceId\":6,\"configUrl\":\"https://example.invalid/theme.json\"}]}");
        String original = "{\"schemaVersion\":1,\"themes\":[]}";
        Files.writeString(temp.resolve("catalog.json"), original);
        var config = descriptor();
        config.addProperty("preview", "file:///private/preview.jpg");
        ThemeDescriptor.write(temp.resolve("theme.json"), config);
        assertThrows(IllegalArgumentException.class, () -> ThemeDescriptor.syncCatalog(temp, temp.resolve("theme.json")));
        assertEquals(original, Files.readString(temp.resolve("catalog.json")));
    }

    @Test void catalogSyncUsesDescriptorOnlyAndMarketWithholdsUnreleasedDownload() throws Exception {
        Files.writeString(temp.resolve("catalog.sources.json"), "{\"themes\":[{\"id\":\"template-example\",\"marketplaceId\":6,\"configUrl\":\"https://example.invalid/theme.json\"}]}");
        Files.writeString(temp.resolve("catalog.json"), "{\"schemaVersion\":1,\"themes\":[]}");
        ThemeDescriptor.write(temp.resolve("theme.json"), descriptor());
        // The declared repository and download host are deliberately unreachable; sync reads only this descriptor.
        ThemeDescriptor.syncCatalog(temp, temp.resolve("theme.json"));
        Marketplace.export(temp, temp.resolve("marketplace.json"), temp.resolve("template.json"));
        var item = ThemeFiles.json(temp.resolve("marketplace.json")).getAsJsonArray("themes").get(0).getAsJsonObject();
        assertEquals(6, item.get("id").getAsInt());
        assertFalse(item.get("installable").getAsBoolean());
        assertFalse(item.has("sourceDirectory"));
        assertFalse(item.has("distribution"));
        assertEquals(0, JsonParser.parseString(Files.readString(temp.resolve("template.json"))).getAsJsonArray().size());
        assertFalse(Files.exists(temp.resolve("template-example")));
    }
}
