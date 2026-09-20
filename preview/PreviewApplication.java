import com.google.gson.Gson;
import com.hibegin.common.dao.DataSourceWrapper;
import com.hibegin.common.util.http.handle.CloseResponseHandle;
import com.hibegin.http.HttpMethod;
import com.hibegin.http.server.WebServerBuilder;
import com.hibegin.http.server.api.HttpRequest;
import com.hibegin.http.server.api.HttpResponse;
import com.hibegin.http.server.util.PathUtil;
import com.zrlog.business.plugin.CacheManagerPlugin;
import com.zrlog.business.plugin.PluginCorePlugin;
import com.zrlog.business.version.UpgradeVersionHandler;
import com.zrlog.common.Constants;
import com.zrlog.common.vo.AdminTokenVO;
import com.zrlog.install.business.service.InstallService;
import com.zrlog.install.business.vo.InstallConfigVO;
import com.zrlog.install.web.InstallConstants;
import com.zrlog.install.web.config.DefaultInstallConfig;
import com.zrlog.plugin.IPlugin;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpHeaders;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.zrlog.blog.web.BlogWebSetup;
import com.zrlog.common.ZrLogConfig;
import com.zrlog.common.TokenService;
import com.zrlog.data.cache.CacheServiceImpl;
import com.zrlog.web.WebSetup;
import com.zrlog.web.inteceptor.DefaultInterceptor;
import com.zrlog.business.template.util.TemplateDownloadUtils;
import com.zrlog.model.WebSite;
import org.jsoup.nodes.Element;
/** Fixture bootstrap only; all routes, installation and rendering come from the locked ZrLog release. */
public class PreviewApplication {
    private static final Gson GSON = new Gson();
    private static ReviewContent content;
    private static boolean showComments;

    public static void main(String[] args) throws Exception {
        Path root = Path.of(args[0]);
        Path fixtures = Path.of(args[1]);
        String theme = "/include/templates/" + args[2];
        int port = Integer.parseInt(args[3]);
        boolean empty = Boolean.parseBoolean(args[4]);
        showComments = Boolean.parseBoolean(args[5]);
        System.setProperty("sws.run.mode", "dev");
        Constants.init();
        PathUtil.setRootPath(root.toString());
        // The Java launcher always supplies a fresh isolated directory.
        if (Files.exists(root.resolve("conf/install.lock"))) {
            throw new IllegalStateException("Preview requires a fresh runtime directory");
        }
        InstallConfigVO install = GSON.fromJson(Files.readString(fixtures.resolve("install.json")), InstallConfigVO.class);
        install.getAppendWebsite().put("host", "127.0.0.1:" + port);
        install.getConfigMsg().setPassword(java.util.UUID.randomUUID().toString());
        InstallConstants.installConfig = new DefaultInstallConfig() {
            @Override public String defaultTemplatePath() { return theme; }
            @Override public String getZrLogSqlVersion() { return String.valueOf(UpgradeVersionHandler.SQL_VERSION); }
        };
        if (!new InstallService(InstallConstants.installConfig, install).install()) {
            throw new IllegalStateException("ZrLog installation failed");
        }
        if (args.length > 7) {
            TemplateDownloadUtils.installByZipFile(new File(args[7]), theme);
        }
        PreviewConfig config = new PreviewConfig(port);
        Constants.zrLogConfig = config;
        content = GSON.fromJson(Files.readString(fixtures.resolve("content.json")), ReviewContent.class);
        if (empty) {
            content.articles.clear();
            content.comments.clear();
            content.types.clear();
            content.tags.clear();
            content.links.clear();
        }
        seedReviewContent((DataSourceWrapper) config.getDataSource(), content);
        @SuppressWarnings("unchecked")
        Map<String, Object> settings = GSON.fromJson(Files.readString(Path.of(args[6])), Map.class);
        new WebSite().updateTemplateConfigMap(theme, settings);
        config.getCacheService().refreshInitData();
        System.out.println("Preview ready: http://127.0.0.1:" + port + "/ (" + theme + ")");
        new WebServerBuilder.Builder().config(config).build().start();
    }

    private static class PreviewConfig extends ZrLogConfig {
        PreviewConfig(int port) {
            super(port, null, "");
            serverConfig.setHost("127.0.0.1");
            serverConfig.setDisableSavePidFile(true);
            webSetups.add(new BlogWebSetup(this, "", false));
            webSetups.forEach(WebSetup::setup);
            serverConfig.addInterceptor(DefaultInterceptor.class);
        }
        @Override public DataSourceWrapper configDatabase() throws Exception {
            dataSource = super.configDatabase();
            if (dataSource != null) cacheService = new CacheServiceImpl();
            return dataSource;
        }
        @Override protected TokenService initTokenService() { return null; }
        @Override public List<IPlugin> getBasePluginList() {
            return List.of(new PreviewPlugin(), new CacheManagerPlugin(this));
        }
    }

    private static String pluginHtml(String uri) {
        if (!showComments || !uri.startsWith("/comment/widget")) return "";
        String id = uri.replaceFirst(".*articleId=([0-9]+).*", "$1");
        Element section = new Element("section").attr("data-preview-comment", "true");
        for (ReviewComment comment : safe(content.comments)) {
            if (!String.valueOf(comment.articleId).equals(id)) continue;
            section.appendElement("strong").text(comment.userName);
            section.appendElement("p").text(comment.content);
        }
        return section.children().isEmpty() ? "" : section.outerHtml();
    }

    private static void seedReviewContent(DataSourceWrapper dataSource, ReviewContent content) throws SQLException {
        var runner = dataSource.getQueryRunner();
        runner.update("delete from comment");
        runner.update("delete from log");
        runner.update("delete from type");
        runner.update("delete from tag");
        runner.update("delete from link");
        runner.update("delete from lognav");
        runner.update("update user set header=? where userId=1", "/attached/avatar.svg");

        for (ReviewNavigation navigation : safe(content.navigation)) {
            runner.update("insert into lognav(navId, navName, url, sort, icon) values(?, ?, ?, ?, ?)",
                    navigation.id, navigation.name, navigation.url, navigation.sort, "");
        }
        for (ReviewType type : safe(content.types)) {
            runner.update("insert into type(typeId, typeName, remark, alias, pid, arrange_plugin) "
                            + "values(?, ?, ?, ?, ?, ?)",
                    type.id, type.name, type.remark, type.alias, 0, null);
        }
        for (ReviewTag tag : safe(content.tags)) {
            runner.update("insert into tag(tagId, text, count) values(?, ?, ?)", tag.id, tag.text, tag.count);
        }
        for (ReviewLink link : safe(content.links)) {
            runner.update("insert into link(linkId, linkName, url, alt, sort, status, icon) values(?, ?, ?, ?, ?, ?, ?)",
                    link.id, link.name, link.url, link.alt, link.sort, true, link.icon);
        }
        for (ReviewArticle article : content.articles) {
            runner.update("insert into log(logId, alias, canComment, click, version, content, plain_content, markdown, "
                            + "digest, keywords, thumbnail, recommended, releaseTime, last_update_date, title, typeId, "
                            + "userId, hot, rubbish, privacy, editor_type, arrange_plugin) values(?, ?, ?, ?, ?, ?, ?, "
                            + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    article.id, article.alias, article.canComment, article.click, 0, article.content,
                    article.plainContent, article.markdown, article.digest, article.keywords, article.thumbnail, false,
                    article.releaseTime, article.releaseTime, article.title, article.typeId, 1, false, false, false,
                    "markdown", null);
        }
        for (ReviewComment comment : safe(content.comments)) {
            runner.update("insert into comment(commentId, commTime, hide, have_read, td, userComment, userHome, "
                            + "userIp, userMail, userName, logId, postId, header, user_agent, reply_id) values(?, ?, "
                            + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    comment.id, comment.time, false, false, comment.time, comment.content, "", "127.0.0.1",
                    "reader@example.com", comment.userName, comment.articleId, "memory-" + comment.id, "",
                    "MemoryApplication", null);
        }
    }

    private static <T> List<T> safe(List<T> values) {
        return values == null ? new ArrayList<>() : values;
    }

    private static class PreviewPlugin implements PluginCorePlugin {

        @Override
        public boolean refreshCache(String cacheVersion, HttpRequest request) {
            return false;
        }

        @Override
        public CloseResponseHandle getContext(String uri, HttpMethod method, HttpRequest request,
                                              AdminTokenVO adminTokenVO) {
            CloseResponseHandle handle = new CloseResponseHandle();
            handle.handle(null, memoryResponse(pluginHtml(uri)));
            return handle;
        }

        @Override
        public <T> T requestService(HttpRequest inputRequest, Map<String, String[]> params,
                                    AdminTokenVO adminTokenVO, Class<T> clazz) {
            return null;
        }

        @Override
        public boolean accessPlugin(String uri, HttpRequest request, HttpResponse response,
                                    AdminTokenVO adminTokenVO) throws URISyntaxException {
            return false;
        }

        @Override
        public String getToken() {
            return "memory";
        }

        @Override
        public boolean start() {
            return true;
        }

        @Override
        public boolean autoStart() {
            return false;
        }

        @Override
        public boolean isStarted() {
            return true;
        }

        @Override
        public boolean stop() {
            return true;
        }

        private static java.net.http.HttpResponse<InputStream> memoryResponse(String body) {
            byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
            return new java.net.http.HttpResponse<>() {
                @Override
                public int statusCode() {
                    return 200;
                }

                @Override
                public java.net.http.HttpRequest request() {
                    return java.net.http.HttpRequest.newBuilder(URI.create("http://127.0.0.1/memory-plugin")).build();
                }

                @Override
                public Optional<java.net.http.HttpResponse<InputStream>> previousResponse() {
                    return Optional.empty();
                }

                @Override
                public HttpHeaders headers() {
                    return HttpHeaders.of(Map.of("content-type", List.of("text/html;charset=utf-8")),
                            (name, value) -> true);
                }

                @Override
                public InputStream body() {
                    return new ByteArrayInputStream(bytes);
                }

                @Override
                public Optional<javax.net.ssl.SSLSession> sslSession() {
                    return Optional.empty();
                }

                @Override
                public URI uri() {
                    return URI.create("http://127.0.0.1/memory-plugin");
                }

                @Override
                public HttpClient.Version version() {
                    return HttpClient.Version.HTTP_1_1;
                }
            };
        }
    }

    private static class ReviewContent {
        private List<ReviewNavigation> navigation;
        private List<ReviewType> types;
        private List<ReviewTag> tags;
        private List<ReviewLink> links;
        private List<ReviewArticle> articles;
        private List<ReviewComment> comments;
    }

    private static class ReviewNavigation {
        private int id;
        private String name;
        private String url;
        private int sort;
    }

    private static class ReviewType {
        private int id;
        private String name;
        private String alias;
        private String remark;
    }

    private static class ReviewTag {
        private int id;
        private String text;
        private int count;
    }

    private static class ReviewLink {
        private int id;
        private String name;
        private String url;
        private String alt;
        private String icon;
        private int sort;
    }

    private static class ReviewArticle {
        private int id;
        private String alias;
        private String title;
        private String digest;
        private String plainContent;
        private String content;
        private String markdown;
        private String keywords;
        private String thumbnail;
        private int typeId;
        private String releaseTime;
        private boolean canComment;
        private int click;
    }

    private static class ReviewComment {
        private int id;
        private int articleId;
        private String userName;
        private String content;
        private String time;
    }
}
