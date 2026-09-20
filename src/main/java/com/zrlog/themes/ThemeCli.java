package com.zrlog.themes;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.concurrent.Callable;

@Command(name = "theme", mixinStandardHelpOptions = true, description = "ZrLog theme development toolkit",
        subcommands = {ThemeCli.Check.class, ThemeCli.Pack.class, ThemeCli.Preview.class, ThemeCli.Smoke.class, ThemeCli.Init.class, ThemeCli.Catalog.class,
                ThemeCli.Build.class, ThemeCli.Publish.class, ThemeCli.CatalogSync.class, ThemeCli.ReleaseConfig.class, ThemeCli.MarketExport.class})
public class ThemeCli implements Runnable {
    static Path root() { return Path.of(System.getProperty("zrlog.templates.dir", ".")).toAbsolutePath().normalize(); }
    public void run() { new CommandLine(this).usage(System.out); }
    public static void main(String[] args) {
        int status = new CommandLine(new ThemeCli()).setExecutionExceptionHandler((error, command, result) -> {
            command.getErr().println("Error: " + error.getMessage());
            return 1;
        }).execute(args);
        System.exit(status);
    }
    @Command(name = "check", mixinStandardHelpOptions = true, description = "Check the theme package contract (use preview for rendering)")
    static class Check implements Callable<Integer> {
        @Parameters(index = "0") Path source;
        public Integer call() throws Exception { System.out.println("Theme contract OK: " + ThemeFiles.check(source).files().size() + " runtime files"); return 0; }
    }
    @Command(name = "package", mixinStandardHelpOptions = true, description = "Create a reproducible ZIP and SHA-256")
    static class Pack implements Callable<Integer> {
        @Parameters(index = "0") Path source;
        @Option(names = "--output", required = true) Path output;
        public Integer call() throws Exception { System.out.println(ThemeFiles.pack(source, output)); return 0; }
    }
    @Command(name = "preview", mixinStandardHelpOptions = true, description = "Preview a theme directory or installed ZIP on the locked ZrLog release")
    static class Preview implements Callable<Integer> {
        @Parameters(index = "0") Path source;
        @Option(names = "--port", defaultValue = "7080") int port;
        @Option(names = "--empty") boolean empty;
        enum Comments { fixture, empty }
        @Option(names = "--comments", defaultValue = "fixture") Comments comments;
        @Option(names = "--settings") Path settings;
        @Option(names = "--id", description = "Theme ID when the checkout directory has a different name") String id;
        public Integer call() throws Exception { return PreviewRuntime.run(root(), source, port, empty, comments == Comments.fixture, settings, id); }
    }
    @Command(name = "smoke", mixinStandardHelpOptions = true, description = "Verify local preview routes, HTML and referenced assets")
    static class Smoke implements Callable<Integer> {
        @Option(names = "--base-url", defaultValue = "http://127.0.0.1:7080") String baseUrl;
        @Option(names = "--empty") boolean empty;
        public Integer call() throws Exception { return SmokeCheck.run(root(), baseUrl, empty); }
    }
    @Command(name = "init", mixinStandardHelpOptions = true, description = "Create a standalone theme from the starter")
    static class Init implements Callable<Integer> {
        @Parameters(index = "0") Path destination;
        public Integer call() throws Exception {
            ThemeFiles.require(ThemeFiles.ID.matcher(destination.getFileName().toString()).matches(), "Theme directory must be named template-<id>");
            ThemeFiles.copyTree(root().resolve("starter"), destination);
            var descriptor = ThemeFiles.json(destination.resolve("theme.json"));
            descriptor.addProperty("id", destination.getFileName().toString());
            descriptor.addProperty("repository", "https://github.com/your-name/" + destination.getFileName());
            ThemeDescriptor.write(destination.resolve("theme.json"), descriptor);
            System.out.println("Created " + destination.toAbsolutePath() + "; run git init there to start an independent repository");
            return 0;
        }
    }
    @Command(name = "build", mixinStandardHelpOptions = true, description = "Build a theme from its repository theme.json")
    static class Build implements Callable<Integer> {
        @Parameters(index = "0") Path repository;
        @Option(names = "--output-dir", defaultValue = "dist") Path output;
        public Integer call() throws Exception { System.out.println(ThemeDescriptor.build(repository, output)); return 0; }
    }
    @Command(name = "publish", mixinStandardHelpOptions = true, description = "Build and upload via the shared GitHub Release or S3 publisher")
    static class Publish implements Callable<Integer> {
        @Parameters(index = "0") Path repository;
        @Option(names = "--tag", required = true) String tag;
        @Option(names = "--output-dir", defaultValue = "dist") Path output;
        @Option(names = "--dry-run", description = "Build package and release descriptor without uploading") boolean dryRun;
        public Integer call() throws Exception { ThemePublisher.publish(repository, output, tag, dryRun); return 0; }
    }
    @Command(name = "release-config", mixinStandardHelpOptions = true, description = "Create a descriptor for an independently maintained release ZIP")
    static class ReleaseConfig implements Callable<Integer> {
        @Parameters(index = "0") Path config;
        @Option(names = "--archive", required = true) Path archive;
        @Option(names = "--tag", required = true) String tag;
        @Option(names = "--url", required = true) String url;
        @Option(names = "--output", required = true) Path output;
        public Integer call() throws Exception { ThemeDescriptor.write(output, ThemeDescriptor.release(ThemeFiles.json(config), archive, tag, url)); return 0; }
    }
    @Command(name = "catalog-sync", mixinStandardHelpOptions = true, description = "Refresh the index by fetching only registered theme descriptors")
    static class CatalogSync implements Callable<Integer> {
        @Option(names = "--local", description = "Validate a local descriptor before it is published") Path local;
        public Integer call() throws Exception { ThemeDescriptor.syncCatalog(root(), local); return 0; }
    }
    @Command(name = "market-export", mixinStandardHelpOptions = true, description = "Export the versioned marketplace feed and optional zrlog-www compatible list")
    static class MarketExport implements Callable<Integer> {
        @Option(names = "--output", defaultValue = "marketplace.json") Path output;
        @Option(names = "--legacy-output") Path legacyOutput;
        public Integer call() throws Exception { Marketplace.export(root(), output, legacyOutput); return 0; }
    }
    @Command(name = "catalog-check", mixinStandardHelpOptions = true, description = "Check independent and legacy theme index entries")
    static class Catalog implements Callable<Integer> {
        public Integer call() throws Exception {
            var ids = new HashSet<String>();
            for (var element : ThemeFiles.json(root().resolve("catalog.json")).getAsJsonArray("themes")) {
                var theme = element.getAsJsonObject();
                String id = theme.get("id").getAsString();
                ThemeFiles.require(ThemeFiles.ID.matcher(id).matches() && ids.add(id), "Invalid or duplicate catalog ID: " + id);
                String status = theme.get("status").getAsString();
                if (status.equals("independent")) {
                    ThemeFiles.require(theme.get("repository").getAsString().startsWith("https://github.com/") && theme.has("testedRuntime"), "Incomplete independent theme: " + id);
                    ThemeFiles.require(!Files.exists(root().resolve(id)), "Independent source must not remain in index: " + id);
                } else {
                    ThemeFiles.require(status.equals("legacy") && Files.isRegularFile(root().resolve(id).resolve("template.properties")), "Invalid legacy theme: " + id);
                }
            }
            System.out.println("Catalog OK: " + ids.size() + " themes");
            return 0;
        }
    }
}
