package com.zrlog.themes;

import java.nio.file.Path;
import java.util.List;

/** Publication runs in the theme repository/CI, never as part of catalog synchronization. */
final class ThemePublisher {
    static void publish(Path repository, Path outputDirectory, String tag, boolean dryRun) throws Exception {
        var config = ThemeDescriptor.validate(ThemeFiles.json(repository.resolve("theme.json")));
        var distribution = config.getAsJsonObject("distribution");
        ThemeFiles.require(distribution.get("mode").getAsString().equals("shared"), "This theme manages its own Release; only synchronize its descriptor");
        String target = distribution.get("target").getAsString();
        String id = config.get("id").getAsString();
        String repo = config.get("repository").getAsString();
        Path archive = ThemeDescriptor.build(repository, outputDirectory);
        Path checksum = archive.resolveSibling(archive.getFileName() + ".sha256");
        String url;
        String bucket = null;
        if (target.equals("github-release")) {
            ThemeFiles.require(repo.matches("https://github\\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+"), "GitHub publication requires an owner/repository URL");
            url = repo + "/releases/download/" + tag + "/" + archive.getFileName();
        } else {
            bucket = System.getenv("ZRLOG_THEME_S3_BUCKET");
            ThemeFiles.require(bucket != null && bucket.matches("[a-z0-9][a-z0-9.-]+"), "Set ZRLOG_THEME_S3_BUCKET for S3 publication");
            url = distribution.get("publicBaseUrl").getAsString().replaceAll("/+$", "") + "/" + id + "/" + tag + "/" + archive.getFileName();
        }
        Path descriptor = outputDirectory.resolve("theme.json").toAbsolutePath();
        ThemeDescriptor.write(descriptor, ThemeDescriptor.release(config, archive, tag, url));
        if (target.equals("github-release")) {
            execute(List.of("gh", "release", "create", tag, "--repo", repo, "--verify-tag", "--title", config.get("name").getAsString() + " " + tag,
                    "--generate-notes", archive.toString(), checksum.toString(), descriptor.toString()), dryRun);
        } else {
            String prefix = distribution.has("keyPrefix") ? distribution.get("keyPrefix").getAsString() : "attachment/template";
            ThemeFiles.require(prefix.matches("[A-Za-z0-9_-]+(?:/[A-Za-z0-9_-]+)*"), "Invalid S3 keyPrefix");
            String destination = "s3://" + bucket + "/" + prefix + "/" + id + "/";
            execute(List.of("aws", "s3", "cp", archive.toString(), destination + tag + "/" + archive.getFileName()), dryRun);
            execute(List.of("aws", "s3", "cp", checksum.toString(), destination + tag + "/" + checksum.getFileName()), dryRun);
            // Publish the current descriptor last, only after the package and checksum succeeded.
            execute(List.of("aws", "s3", "cp", descriptor.toString(), destination + "theme.json", "--content-type", "application/json"), dryRun);
        }
    }

    private static void execute(List<String> command, boolean dryRun) throws Exception {
        if (dryRun) { System.out.println("Prepared upload (not executed): " + command); return; }
        int status = new ProcessBuilder(command).inheritIO().start().waitFor();
        if (status != 0) throw new IllegalStateException(command.get(0) + " failed with exit code " + status);
    }
}
