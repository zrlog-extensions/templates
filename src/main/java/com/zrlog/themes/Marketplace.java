package com.zrlog.themes;

import com.google.gson.JsonArray;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;

import java.nio.file.Path;

/** Public market projection. Internal build paths and publication credentials never enter this feed. */
final class Marketplace {
    static void export(Path root, Path output, Path legacyOutput) throws Exception {
        JsonArray entries = new JsonArray(), installable = new JsonArray();
        for (var element : ThemeFiles.json(root.resolve("catalog.json")).getAsJsonArray("themes")) {
            var source = element.getAsJsonObject();
            if (!source.has("marketplaceId") || source.get("marketplaceId").isJsonNull()) continue;
            JsonObject item = new JsonObject();
            item.add("id", source.get("marketplaceId"));
            item.add("themeId", source.get("id"));
            copy(source, item, "name", "name");
            copy(source, item, "author", "author");
            copy(source, item, "description", "desc");
            copy(source, item, "preview", "image");
            copy(source, item, "repository", "sourceUrl");
            copy(source, item, "createdDate", "createdDate");
            copy(source, item, "tags", "tags");
            copy(source, item, "en", "en");
            copy(source, item, "engine", "engine");
            copy(source, item, "testedRuntime", "testedRuntime");
            copy(source, item, "maintenance", "maintenance");
            item.addProperty("fileName", source.get("id").getAsString() + ".zip");
            String releaseField = source.has("latestRelease") && !source.get("latestRelease").isJsonNull() ? "latestRelease" : "historicalRelease";
            boolean published = source.has(releaseField) && !source.get(releaseField).isJsonNull();
            item.addProperty("status", published ? "published" : "unreleased");
            item.addProperty("installable", published);
            if (published) {
                var release = source.getAsJsonObject(releaseField);
                item.addProperty("version", release.get("tag").getAsString().replaceFirst("^v", ""));
                copy(release, item, "url", "downloadUrl");
                copy(release, item, "sha256", "sha256");
                installable.add(item.deepCopy());
            } else {
                item.add("version", JsonNull.INSTANCE);
                item.add("downloadUrl", JsonNull.INSTANCE);
                item.add("sha256", JsonNull.INSTANCE);
            }
            entries.add(item);
        }
        JsonObject feed = new JsonObject();
        feed.addProperty("schemaVersion", 1);
        feed.add("themes", entries);
        ThemeDescriptor.write(output, feed);
        if (legacyOutput != null) {
            // Matches zrlog-www's existing List<Template> JSON loader, including numeric IDs and en.*.
            java.nio.file.Files.createDirectories(legacyOutput.toAbsolutePath().getParent());
            java.nio.file.Files.writeString(legacyOutput, new com.google.gson.GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create().toJson(installable) + "\n");
        }
        System.out.println("Market feed: " + entries.size() + " listed, " + installable.size() + " installable");
    }

    private static void copy(JsonObject source, JsonObject target, String from, String to) {
        if (source.has(from)) target.add(to, source.get(from).deepCopy());
    }
}
