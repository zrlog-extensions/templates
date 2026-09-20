# 独立主题与 JSP 归档迁移

从 templates 的 `fd28a514fae4246b87b7dd38f45a7cc8f274e88d` 源码基线通过 `git subtree split` 提取各主题历史。主题 ID 不变；templates 只登记配置。

| 仓库 | 内容与状态 | 验证 |
| --- | --- | --- |
| [template-signal-notes](https://github.com/zrlog-extensions/template-signal-notes) | 独立 FreeMarker 主题 | 3.9.2 目录、ZIP、浏览器；GitHub CI |
| [template-hexo-theme-next](https://github.com/zrlog-extensions/template-hexo-theme-next) | 独立 FreeMarker 主题 | 3.9.2 目录、ZIP |
| [template-sheshui](https://github.com/zrlog-extensions/template-sheshui) | 独立 FreeMarker 主题 | 3.9.2 目录、ZIP |
| [template-simple](https://github.com/zrlog-extensions/template-simple) | 独立 FreeMarker 主题 | 3.9.2 目录、ZIP |
| [templates-legacy-jsp](https://github.com/zrlog-extensions/templates-legacy-jsp) | materialwp、metro、proteus-themes、startbootstrap；全部不再维护 | 仅归档配置校验；当前运行时未验证 |

上述 5 个仓库均已公开推送。4 个 FreeMarker 主题独立维护，4 个 JSP 主题集中归档；索引通过各仓库中的 theme.json 获取配置。

## 兼容修复与归档边界

- FreeMarker 元信息补齐 digest、修正不存在的 staticResource、源码地址改为独立仓库。
- NexT 去除导致 HTML head 被解析为空的 BOM；旧跨目录评论 include 改为本主题片段；提供默认头像和缺失引号图标；样式仅引用现有字体和图片。
- Simple 去除 BOM，修正 favicon 的双斜线地址；正文使用运行时共享 Markdown 样式，评论使用当前插件接口，避免旧 comm.cnt 字段导致详情页 500；补齐分页语言文件。
- 涉水主题仅调整元信息和开发/发布配置。
- JSP 通过 git subtree 汇入一个归档工程，保留原源码、作者及各自历史；每个目录添加不再维护说明和 theme.json。没有构建/上传/发布 CI，不进行运行时升级。

归档配置使用 maintenance=unmaintained、distribution.mode=none、testedRuntime=null、latestRelease=null。索引可以记录归档来源，但不给这些主题分配市场 ID 或安装入口。

原市场的 Simple / NexT / 涉水保留数字 ID 3 / 4 / 5 和已有下载地址；Signal Notes 使用 6。全部独立主题尚未发布新的 Release；历史包通过 historicalRelease 保留，首次独立发布后 latestRelease 优先生效。

## 验证与索引

每个 FreeMarker 主题在锁定的真实 3.9.2 运行时中验证目录和 ZIP 安装，覆盖中英文首页、分页、分类、标签、归档、搜索、缺失文章、正文表格和本地资源。证据保存在各主题 docs/runtime-acceptance.json（Signal Notes 另有浏览器验收记录）。新增三个主题本次未做完整桌面/移动端视觉验收。

索引同步只获取 catalog.sources.json 声明的 theme.json，生成 catalog.json、marketplace.json 和兼容 zrlog-www 的 template.json。官网消费接入仍是后续工作，需同时去掉 TemplateController 对旧源码地址的覆盖。
