# ZrLog 主题基础规范 v1

本规范面向独立 FreeMarker 主题。试点验证基准为 `preview/runtime.lock.json` 中的 ZrLog 3.9.2；通过该基准不意味着兼容所有历史或未来版本。

历史 JSP 主题集中在 templates-legacy-jsp 归档工程，提供 theme.json 记录来源，但不适用下述 FreeMarker 文件检查及公共预览。归档配置使用 engine=jsp、maintenance=unmaintained、distribution.mode=none、testedRuntime=null，不再维护或发布。

## 仓库与目录

仓库及主题 ID 使用 `template-<小写字母、数字、连字符>`，如 `template-signal-notes`。仓库根目录直接放主题运行文件：

```text
template.properties
index.ftl
page.ftl
detail.ftl
404.ftl
empty.ftl
header.ftl
footer.ftl
article.ftl
pager.ftl
comment.ftl
language/i18n_zh_CN.properties
language/i18n_en_US.properties
setting/config-form.json
css/
js/
images/
```

规范要求元信息、首页、列表、详情、404 和中英文语言文件。公共片段按需要拆分；骨架提供 empty.ftl 适配空结果。此处为新主题开发约定，不改变服务端接受旧主题的规则。

README、AGENTS、docs、examples、bin、CI 和 dist 属于仓库开发内容，不属于安装包。

## 元信息与静态资源

`template.properties` 使用 UTF-8、每行一个 `key=value`，要求 author、name、url、digest、version、staticResource。url 指向主题来源，不填写设计参考站点。staticResource 声明实际存在的资源目录；previewImages 如存在，必须引用包内图片。

主题资源使用 `${url}/css/style.css`；运行时共享样式使用 `${baseUrl}assets/css/markdown.css` 等实际存在的路径。不要把全局 assets 路径描述成所有主题目录的通用映射。

公共打包器只包含 FTL、template.properties、language 下的 properties、setting/config-form.json，以及 staticResource 内的 CSS/JS/图片/字体。拒绝符号链接，排除隐藏文件和开发目录。新增资源类型应先更新规范和检查器。

## 模板数据

根对象是 pageInfo 本身：使用 `title`、`webs`、`init`、`_res`，不要添加 `model` 层。

- 列表：`data.rows`；详情：`log`。
- 链接使用 `log.url`、`log.typeUrl`、tag.url 等服务端字段。
- 分类、标签、导航、友链：`init.types`、`init.tags`、`init.logNavs`、`init.links`。
- 封面：`log.thumbnail`；作者头像：`log.header`。
- 对可空对象、列表、字符串使用 `??`、`?has_content`、`!`。
- 普通文本/属性正确转义；正文等既有 HTML 字段保持渲染语义。

完整字段说明由 [zrlog-blog-web 的文档](https://github.com/zrlog/zrlog-blog-web-parent/blob/main/docs/freemarker-template-data.md) 维护。文档与基准发布版本不一致时，核对所锁版本的 Java DTO 和实际渲染，禁止猜字段。公共工具的静态检查不替代 FreeMarker 渲染。

## 国际化与配置

文案放 `language/i18n_*.properties`，从 `_res` 读取并提供回退。Java properties 的中文可使用 Unicode 转义，保持与运行时加载方式兼容。

`setting/config-form.json` 是以配置名为键的对象：

```json
{
  "introText": {
    "label": "首页导语",
    "htmlElementType": "textarea",
    "type": "text",
    "placeholder": "一句简短介绍"
  }
}
```

模板读取 `${_res['introText']!''}`。`type` 与 `htmlElementType` 是不同字段，不使用旧文档的数组格式。预览 `--settings` 文件只包含配置值，例如 `{"introText":"我的记录"}`。

## 设计与交付

布局、字体、配色、暗色模式实现属于主题自身设计说明。公共要求是页面能运行、移动端不溢出、正文可读、交互可访问；不将 Signal Notes 的瀑布流或宽度规则强加给其他主题。

交付源码、设计说明、预览图、验收记录和 ZIP/SHA-256。每个主题独立发布，Release tag 与 template.properties 版本一致。索引只引用已发布制品。上传与启用是两个操作。
