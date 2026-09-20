# 固定主题预览环境

基准是官方 ZrLog 3.9.2 Java ZIP，地址、源码提交、SHA-256 和夹具版本记录在 runtime.lock.json。下载包保存在 `.cache/`，每次运行重新校验并解压；不会读取本机 Maven 制品或远端数据库。

需要 JDK 17+，公共工具使用 Maven Wrapper 构建。首次需要访问 dl.zrlog.com；缓存后可以离线运行。CI 使用 JDK 17。

```bash
bin/theme preview /absolute/path/template-signal-notes --port 7080
```

程序只监听 127.0.0.1。每次启动新建 `.preview/run-*/site`，调用官方 InstallService 初始化本地 SQLite，注入固定内容，然后通过官方 BlogWebSetup、FreeMarker 和静态资源处理链路提供页面。Ctrl-C 后清理本次临时目录，其他运行实例与源主题不受影响。

目录模式只同步允许进入安装包的文件，每 0.5 秒检查新增、修改和删除，支持编辑后刷新。实际 FreeMarker 缓存由基准版本决定，可能需要稍后再刷新；CSS/JS 修改后使用浏览器强制刷新。元信息、国际化、配置定义或配置值修改后重启。

ZIP 模式先检查文件与路径，然后调用官方 TemplateDownloadUtils.installByZipFile 安装；不把解压成功当作渲染通过。

## 边界

- 预览启动器只负责环境组装，不实现模板引擎、路由或 DTO。
- 仅提供博客前台，不启动管理后台、更新服务或真实插件进程。
- 默认评论返回固定 HTML，`--comments empty` 返回空片段。真实插件交互、后台配置表单与生产部署需要额外集成验收。
- 基准内容保存 HTML 与 Markdown 两种字段，沿用 ZrLog 服务端内容语义；不在浏览器增加另一套 Markdown 转换器。
- 项目包含配置示例，但启动时管理员密码随机生成；此运行环境没有后台入口。

基准 3.9.2 对不存在的文章路径返回空页面和 HTTP 200（并非 HTTP 404）。冒烟检查保留这个已观察到的上游行为，主题工具不修改路由语义；升级基准时应重新核对并更新 notFoundStatus。

## 更新基准

显式选择官方版本，核对发布清单的 ZIP URL、SHA-256 与源码提交，再更新 lock；修改内容时递增 fixtureVersion。更新后跑工具测试、starter 与 Signal Notes 的目录/ZIP 冒烟及桌面/移动浏览器检查，记录结果。

目前仅验证 FreeMarker。其他引擎需要自己的兼容检查和基准包支持，不能仅添加索引字段就宣称支持。
