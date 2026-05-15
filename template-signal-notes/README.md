# Signal Notes 主题维护规范

`template-signal-notes` 是一个 Freemarker 主题，视觉参考 Next.js Blog，但不是复制官方品牌。后续维护这个主题时，先遵守本文档，避免重复确认同一批规则。

## 设计边界

- 只学习 Next.js Blog 的信息层级、卡片节奏、间距、边框、排版和资源区结构。
- 不保留 Next.js / Vercel 的官方 logo、三角 icon、斜线分隔等品牌资产。
- 顶部品牌只显示站点文字：`${_res['navBarBrand']!webs.title!''}`。
- 顶部搜索框不显示快捷键提示，不放 `Learn` 链接。
- 搜索框、主题切换、Deploy 按钮必须保持同一套顶部控件语言，尤其是高度、圆角、背景、hover 和 focus。

## 首页

- 首页入口是 `index.ftl`，实际列表在 `page.ftl`。
- 首页卡片使用瀑布流布局：`.posts-grid` 基于 CSS columns，`.post-card` 使用 `break-inside: avoid`。
- 文章预览图使用 `log.thumbnail`，不要另造字段。
- 预览图 alt 优先使用 `log.thumbnailAlt!log.title`。
- 作者头像使用 `log.header`，没有时保留圆形占位头像。
- 摘要使用 `${log.digest!''}`，并放在 `markdown-body post-card__prose` 中，不能包死在 `<p>` 里。
- 首页卡片需要显示分类，分类字段使用 `log.typeName` / `log.typeUrl`。
- 分类 icon 使用统一的 `.category-icon`，不要引入外部图标资源。

## 详情页

- 详情页入口是 `detail.ftl`，正文片段在 `article.ftl`。
- 详情页最大宽度跟随官方文章页节奏，当前容器是 `860px`。
- `.article-body` 不要再加 `65ch` 限宽；正文、标签、来源、上下篇、评论都跟随详情容器宽度。
- 详情页不要显示首页预览摘要 `log.digest`，避免和正文重复。
- 正文内容使用 `${log.content!''}`，并放在 `markdown-body article-body` 中。
- 作者头像使用 `log.header`，没有时保留圆形占位头像。
- 详情页也需要显示分类，分类字段使用 `log.typeName` / `log.typeUrl`。
- 详情页分类同样使用 `.category-icon`，不要用圆形头像或渐变点表示分类。
- 标签区使用轻量文字链接 `.article-tag`，不要复用 `.tag-chip`。

## Markdown

- 首页摘要和详情正文都必须支持 `markdown-body`。
- 首页卡片内 markdown 需要独立收敛样式，避免标题、列表、引用、代码块、表格撑破卡片。
- 详情页 markdown 需要覆盖通用 `markdown.css` 的浅色表格、边框、引用、代码块样式。
- markdown 暗黑样式不能自己独立跟随 `prefers-color-scheme`；必须使用顶部主题状态派生出的 `html[data-theme-effective]`。

## 暗黑模式

- 主题支持 Light / Dark / System 三态切换。
- 用户选择存储在 `localStorage` 的 `signal-notes-theme`。
- `System` 表示不设置 `data-theme`，但仍由顶部初始化脚本计算 `data-theme-effective`。
- 所有 CSS 暗色变量应挂在 `:root[data-theme-effective="dark"]` 下。
- 代码高亮的 `hljs/light.css` 和 `hljs/dark.css` 默认 `media="not all"`，由顶部主题脚本按 `data-theme-effective` 启用。
- 不要让 markdown 或 hljs 直接用自己的媒体查询做最终主题判断。
- 只要新增 JS 资源，确认 `template.properties` 的 `staticResource` 包含 `js`。

## 辅助区和页脚

- `plugin.ftl` 的“发现更多”不是大卡片信息面板，应保持类似 Next.js footer/resources 的轻量链接列。
- 不要使用大标题、大阴影卡片、宽标签云去压过正文。
- 分类、归档、标签、友链保持 14px 左右的轻量链接样式。

## 数据字段约定

常用字段：

```ftl
${log.title}
${log.url}
${log.digest!''}
${log.content!''}
${log.thumbnail!''}
${log.thumbnailAlt!log.title}
${log.header!''}
${log.userName!''}
${log.typeName!''}
${log.typeUrl!''}
${log.releaseTime?split("T")[0]}
```

全站辅助数据：

```ftl
<#list init.logNavs as nav>...</#list>
<#list init.types as type>...</#list>
<#list init.archiveList as archive>...</#list>
<#list init.tags as tag>...</#list>
<#list init.links as link>...</#list>
```

## 样式复用规则

- 分类 icon 统一使用 `.category-icon`。
- 首页分类容器使用 `.post-card__category`。
- 详情页分类容器使用 `.article-author.article-author--category`。
- 首页标签云仍可使用 `.tag-chip`，但详情页文章标签使用 `.article-tag`。
- 顶部控件优先复用现有变量：`--ds-gray-*`、`--geist-*`、`--ds-focus-ring`。
- 不要热链图标、字体或图片；主题资源必须放进主题目录，并在 `staticResource` 声明。

## 验证

修改后至少运行：

```bash
mvn -q -DskipTests compile
```

如果改了 `js/theme-toggle.js`，还要运行：

```bash
node --check static/include/templates/template-signal-notes/js/theme-toggle.js
```

重点人工检查页面：

- 首页：瀑布流、预览图、markdown 摘要、分类、头像、暗黑模式。
- 详情页：标题区、作者头像、分类 icon、正文 markdown、标签、评论、暗黑模式。
- 顶部导航：搜索框、主题切换、Deploy 按钮在桌面和移动端的高度和视觉一致性。
