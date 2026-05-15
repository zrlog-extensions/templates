# ZrLog 主题开发指南

这个目录存放 ZrLog 官方和内置主题。运行时对应 ZrLog 的 `/include/templates/` 目录，源码中对应 `static/include/templates/`。

ZrLog 主题支持 JSP 和 Freemarker。新主题建议优先使用 Freemarker，目录名使用 `template-xxx`，例如 `template-signal-notes`。

参考文章：https://blog.zrlog.com/make-theme-for-zrlog.html

## 主题专项文档

部分主题有更细的维护规范。修改这些主题前，先阅读主题目录内的 `README.md`。

- `template-signal-notes/README.md`：Next.js Blog 风格主题的布局、字段、暗黑模式、markdown、分类 icon、预览图和头像约定。

## 目录结构

一个 Freemarker 主题通常长这样：

```text
template-your-theme/
  template.properties
  index.ftl
  page.ftl
  detail.ftl
  article.ftl
  header.ftl
  footer.ftl
  pager.ftl
  comment.ftl
  plugin.ftl
  404.ftl
  css/
    style.css
  js/
  images/
    preview.jpg
  language/
    i18n_zh_CN.properties
    i18n_en_US.properties
  setting/
    config-form.json
```

不是每个文件都强制存在，但建议保持这个骨架，便于复用和 AI 工具快速理解。

## 主题元信息

`template.properties` 是主题入口元信息：

```properties
author=your-name
name=Your Theme Name
url=https://example.com
digest=Theme description
version=1.0
staticResource=css,js,images,fonts
previewImages=images/preview.jpg
```

常用字段：

- `author`：主题作者。
- `name`：后台展示的主题名称。
- `url`：主题来源或作者主页。
- `digest`：主题简介。
- `version`：主题版本。
- `staticResource`：需要作为静态资源暴露的目录，多个目录用英文逗号分隔。
- `previewImages`：主题预览图路径。

## 页面模板职责

推荐按职责拆分，不要把所有页面写在一个文件里：

- `index.ftl`：首页入口，通常直接 `<#include "page.ftl">`。
- `page.ftl`：文章列表页、分类页、标签页、搜索结果页、归档页。
- `detail.ftl`：文章详情页外壳，负责标题、日期、作者、正文布局。
- `article.ftl`：文章正文片段，负责 `log.content`、标签、原文链接、上一篇/下一篇。
- `header.ftl`：HTML 头部、导航、CSS/JS 引入，通常打开 `<main>`。
- `footer.ftl`：页脚，通常关闭 `</main></body></html>`。
- `pager.ftl`：列表分页。
- `comment.ftl`：评论插件渲染。
- `plugin.ftl`：侧栏、发现更多、分类、标签、归档、友链等辅助区。
- `404.ftl`：无内容或不存在页面。

## 常用 Freemarker 数据

模板里常用的数据对象如下。

站点信息：

```ftl
${baseUrl}              <#-- 站点基础 URL，拼静态资源和首页链接常用 -->
${host!''}              <#-- 当前站点 host -->
${webs.title!''}        <#-- 站点标题 -->
${webs.second_title!''} <#-- 站点副标题 -->
${webs.description!''}  <#-- 站点描述 -->
${webs.icp!''}          <#-- ICP 信息 -->
${webs.webCm!''}        <#-- 统计代码等自定义 HTML -->
```

列表数据：

```ftl
<#if data?? && data.rows?has_content>
  <#list data.rows as log>
    ${log.title}
    ${log.url}
    ${log.digest!''}
    ${log.releaseTime}
    ${log.releaseTime?split("T")[0]}
    ${log.typeName!''}
    ${log.typeUrl!''}
  </#list>
</#if>
```

详情页文章对象：

```ftl
<#if log??>
  ${log.title}
  ${log.content!''}
  ${log.digest!''}
  ${log.releaseTime}
  ${log.userName!''}
  ${log.noSchemeUrl!''}
  ${log.canComment?c}
</#if>
```

文章标签：

```ftl
<#if log.tags?has_content>
  <#list log.tags as tag>
    <a href="${tag.url}">${tag.name}</a>
  </#list>
</#if>
```

上一篇和下一篇：

```ftl
<#if log.lastLog?? && log.lastLog.url?has_content>
  <a href="${log.lastLog.url}">${log.lastLog.title}</a>
</#if>

<#if log.nextLog?? && log.nextLog.url?has_content>
  <a href="${log.nextLog.url}">${log.nextLog.title}</a>
</#if>
```

全站辅助数据：

```ftl
<#list init.logNavs as nav>
  <a href="${nav.url}">${nav.navName}</a>
</#list>

<#list init.types as type>
  <a href="${type.url}">${type.typeName}</a>
</#list>

<#list init.archiveList as archive>
  <a href="${archive.url}">${archive.text}</a>
</#list>

<#list init.tags as tag>
  <a href="${tag.url}">${tag.text}</a>
</#list>

<#list init.links as link>
  <a href="${link.url}" title="${link.alt}" target="_blank">${link.linkName}</a>
</#list>
```

页面上下文提示：

```ftl
${tipsType!''} <#-- 当前页面类型，比如搜索、分类、标签、归档 -->
${tipsName!''} <#-- 当前页面名称或关键词 -->
```

## 国际化文案

主题文案放在 `language/i18n_zh_CN.properties` 和 `language/i18n_en_US.properties`。

模板中使用 `_res` 读取：

```ftl
${_res.readArticle!'Read article'}
${_res.searchTip!'Search articles'}
${_res.backHome!'Back to home'}
```

建议所有主题自带文案都走 `_res`，并提供默认值，避免缺少语言 key 时页面报错或展示空白。

## 静态资源

静态资源建议放在主题目录下的 `css/`、`js/`、`images/`、`fonts/`，并在 `template.properties` 的 `staticResource` 声明。

在模板中引入资源：

```ftl
<link rel="stylesheet" href="${baseUrl}assets/css/style.css"/>
<script src="${baseUrl}assets/js/main.js"></script>
```

注意：这里的 `assets/` 会映射到当前主题声明的静态资源目录，不要写成源码目录路径。

## 插件渲染

可以通过 `<plugin>` 标签渲染插件页面或组件：

```ftl
<plugin name="pluginName" view="page" param="articleId=${log.logId}"></plugin>
```

评论框常见写法：

```ftl
<#if log.canComment>
  <section id="comment">
    <plugin name="${website.comment_plugin_name}" view="widget" param="articleId=${log.logId}"/>
  </section>
</#if>
```

用途包括评论框、打赏插件、相关文章推荐等。实现可参考：

https://github.com/zrlog-extensions/zrlog-blog-web/tree/main/src/main/java/com/zrlog/blog/web/template/ResponseRenderPrintWriter.java

## 主题配置

如果主题需要可配置项，添加 `setting/config-form.json`。配置项会出现在后台主题设置中，保存后可通过 `_res['key']` 读取。

示例：

```json
[
  {
    "name": "introText",
    "type": "textarea",
    "label": "Intro text",
    "placeholder": "A short description for the homepage."
  }
]
```

模板中使用：

```ftl
${_res['introText']!''}
```

## 开发流程

1. 在 `static/include/templates/` 下复制一个现有 Freemarker 主题目录。
2. 改目录名为 `template-your-theme`。
3. 更新 `template.properties`，尤其是 `name`、`version`、`staticResource`。
4. 先完成 `header.ftl`、`footer.ftl`、`page.ftl`、`detail.ftl`。
5. 再补 `pager.ftl`、`comment.ftl`、`plugin.ftl`、`404.ftl`。
6. 把所有展示文案放入 `language/*.properties`。
7. 把 CSS/JS/图片放入主题目录，并确认 `staticResource` 已声明。
8. 运行 `mvn -q -DskipTests compile` 验证工程编译。
9. 在真实 ZrLog 环境切换主题，检查首页、列表页、详情页、搜索页、分类页、标签页、归档页、404、评论区。

## 设计建议

- 先选一个明确参考对象，再按页面结构高仿，不要只套颜色和字体。
- 首页、详情页、辅助区、页脚应使用同一套间距、字号、边框和链接规则。
- 列表卡片和详情正文要分别设计，不能用同一套卡片样式硬套。
- 主题附加功能区应降噪，避免压过正文。
- 移动端至少检查导航、文章列表、文章标题、正文、分页和评论区。
- 不要热链外部图标或字体，尽量把资源放入主题目录。

## Unix 开发方式

可以使用软链接，将本工程的 `static/include/templates` 链接到 ZrLog 运行目录的 `/include/templates`，便于实时开发调试。

## 一起完善

欢迎提交 issue 或 PR。
