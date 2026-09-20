package com.zrlog.themes;

import com.google.gson.GsonBuilder;
import org.jsoup.Jsoup;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.time.Duration;
import java.util.*;
import java.util.regex.Pattern;

final class SmokeCheck {
    record PageResult(String route, String language, int status, boolean ok) { }
    record Report(List<PageResult> pages, int resourcesChecked, List<String> failures) { }
    private static final Pattern CSS_URL = Pattern.compile("url\\(\\s*['\"]?([^)'\"\\s]+)");

    static int run(Path root, String baseUrl, boolean empty) throws Exception {
        URI base = URI.create(baseUrl.replaceAll("/+$", ""));
        ThemeFiles.require(Set.of("127.0.0.1", "localhost", "[::1]").contains(base.getHost()), "Use the local preview server");
        var client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).followRedirects(HttpClient.Redirect.NEVER).build();
        List<String> routes = new ArrayList<>(List.of("/", "/search?key=no-such-article-987654", "/does-not-exist"));
        if (!empty) routes.addAll(List.of("/all-2", "/writing-on-my-own-site", "/notes-from-the-past", "/sort/notes", "/tag/ZrLog", "/record/2026_07", "/search?key=ZrLog"));
        int notFoundStatus = ThemeFiles.json(root.resolve("preview/runtime.lock.json")).get("notFoundStatus").getAsInt();
        List<PageResult> pages = new ArrayList<>();
        List<String> failures = new ArrayList<>();
        Set<URI> pending = new LinkedHashSet<>(), checked = new HashSet<>();
        for (String language : List.of("zh-CN", "en-US")) {
            for (String route : routes) {
                URI uri = base.resolve(route);
                var response = get(client, uri, language);
                String text = new String(response.body(), StandardCharsets.UTF_8);
                var document = Jsoup.parse(text, uri.toString());
                int expected = route.equals("/does-not-exist") ? notFoundStatus : 200;
                // Jsoup inserts absent wrappers, so check the original response as well.
                boolean ok = response.statusCode() == expected && response.headers().firstValue("Content-Type").orElse("").contains("text/html")
                        && text.toLowerCase(Locale.ROOT).contains("<html") && text.toLowerCase(Locale.ROOT).contains("<body")
                        && !document.title().isBlank() && !text.matches("(?s).*?(TemplateNotFoundException|InvalidReferenceException|FreeMarker template error).*?");
                if (route.equals("/writing-on-my-own-site")) ok &= document.text().contains("把第一篇文章留给自己的站点") && document.selectFirst("table") != null;
                pages.add(new PageResult(route, language, response.statusCode(), ok));
                if (!ok) failures.add(language + " " + route + ": status=" + response.statusCode() + ", expected=" + expected + "; full rendered HTML required");
                for (var element : document.select("img[src],script[src],link[rel=stylesheet],link[rel~=icon]")) {
                    String value = element.absUrl(element.hasAttr("src") ? "src" : "href");
                    if (!value.isBlank() && !value.startsWith("data:")) pending.add(URI.create(value));
                }
            }
        }
        while (!pending.isEmpty()) {
            URI uri = pending.iterator().next();
            pending.remove(uri);
            if (!checked.add(uri)) continue;
            if (!Objects.equals(uri.getAuthority(), base.getAuthority())) { failures.add("External resource: " + uri); continue; }
            var response = get(client, uri, "zh-CN");
            String mime = response.headers().firstValue("Content-Type").orElse("");
            if (response.statusCode() != 200 || response.body().length == 0 || mime.contains("text/html")) failures.add("Resource failed: " + uri + " (" + response.statusCode() + ", " + mime + ")");
            if (mime.contains("text/css")) {
                var matcher = CSS_URL.matcher(new String(response.body(), StandardCharsets.UTF_8));
                while (matcher.find()) {
                    String value = matcher.group(1);
                    if (!value.startsWith("data:") && !value.startsWith("#")) pending.add(uri.resolve(value));
                }
            }
        }
        System.out.println(new GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create().toJson(new Report(pages, checked.size(), failures)));
        return failures.isEmpty() ? 0 : 1;
    }

    private static HttpResponse<byte[]> get(HttpClient client, URI uri, String language) throws Exception {
        return client.send(HttpRequest.newBuilder(uri).timeout(Duration.ofSeconds(20)).header("Accept-Language", language).build(), HttpResponse.BodyHandlers.ofByteArray());
    }
}
