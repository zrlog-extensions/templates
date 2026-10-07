# ZrLog 主题索引与开发工具

这里是 ZrLog 主题的统一入口，提供**主题索引、基础规范、Java 构建发布工具和固定预览环境**。每个维护中的主题在自己的仓库里开发和发布；主题市场从这里获取展示与下载信息。

## 仓库如何分工

| 工程 | 负责什么 |
| --- | --- |
| **templates（本仓库）** | 规范、起步骨架、基准运行环境、通用构建上传工具，以及主题配置索引 |
| **各 template-* 主题仓库** | 主题源码、设计、`theme.json`、版本和安装包；可使用公共工具或自行维护 Release |
| **zrlog-www** | 使用本仓库固定提交的市场清单快照，呈现主题、预览图和发布状态，并只为可安装主题提供安装入口 |
| **templates-legacy-jsp** | 集中保存已停止维护的 JSP 主题与历史，不再发布新版本 |

索引更新只下载登记的 **`theme.json` 配置文件**。主题源码和 ZIP 保留在主题仓库及其发布地址；公共构建上传由主题仓库或其 CI 调用。

## 主题在哪里

以下 FreeMarker 主题均已通过 ZrLog **3.9.2** 的目录预览和 ZIP 安装冒烟验证。请到对应仓库修改主题、查看设计说明或发布版本。

| 主题 | 独立仓库 |
| --- | --- |
| Open Journal | [template-open-journal](https://github.com/zrlog-extensions/template-open-journal) |
| Signal Notes | [template-signal-notes](https://github.com/zrlog-extensions/template-signal-notes) |
| NexT | [template-hexo-theme-next](https://github.com/zrlog-extensions/template-hexo-theme-next) |
| 涉水轻舟 | [template-sheshui](https://github.com/zrlog-extensions/template-sheshui) |
| 精简主题 | [template-simple](https://github.com/zrlog-extensions/template-simple) |

旧 JSP 主题 materialwp、metro、proteus-themes、startbootstrap 集中在 [templates-legacy-jsp](https://github.com/zrlog-extensions/templates-legacy-jsp)，**不再维护或发布，不进入当前主题市场**，也不适用下面的 FreeMarker 预览环境。原始源码、作者信息和提交历史保留。

## 开发与预览

示例命令需要 **JDK 17+、Git、Bash 和 curl**。通过 Maven Wrapper 构建 Java 工具，预览使用内置 SQLite；首次构建和预览需要联网下载 Maven 依赖及固定运行时。

以 Signal Notes 为例，将两个仓库放在同一级目录：

```bash
git clone https://github.com/zrlog-extensions/templates.git
git clone https://github.com/zrlog-extensions/template-signal-notes.git
cd templates
./mvnw verify
bin/theme check ../template-signal-notes
bin/theme preview ../template-signal-notes
```

访问 **http://127.0.0.1:7080**，修改 FTL/CSS/JS 后刷新页面。预览使用经 SHA-256 校验的官方 ZrLog 3.9.2，通过真实安装链路创建独立 SQLite 数据库，并载入固定文章、分类、标签和评论夹具。退出后清理临时站点；真实评论插件和管理后台不包含在预览中。

以上命令使用当前工具版本。复现某个主题的 CI 时，按该仓库 README 检出 `toolkit.lock.json` 中固定的工具提交。

在 `templates` 目录中创建新主题或验证安装包：

```bash
# 从骨架创建目录，再为它建立独立仓库并填写 theme.json / template.properties
bin/theme init ../template-my-theme

# 按主题配置构建 ZIP 和 SHA-256
bin/theme build ../template-signal-notes --output-dir dist

# 验证目录预览和实际 ZIP 安装后的页面、资源
bash bin/verify-preview.sh ../template-signal-notes 17081
```

`starter/` 是开发骨架；`preview/` 锁定运行时和测试内容。预览直接使用官方路由、模板引擎和页面对象。详细规范见 [主题契约](docs/theme-contract.md)、[开发与 AI 编写指南](docs/development.md) 和 [运行环境说明](preview/README.md)。

## 主题如何发布

两种发布方式都由主题提供 `theme.json`：

| 方式 | 配置与流程 |
| --- | --- |
| 使用公共工具 | `distribution.mode=shared`；调用 `bin/theme build` / `publish`，上传至 GitHub Release 或 S3/R2，可复用公共 GitHub Actions |
| 自行维护 Release | `distribution.mode=release`；自行构建、验收和上传 ZIP，维护包含 tag、URL、SHA-256 的发布配置 |

公共 workflow 在普通 push/PR 时构建和验收，显式推送 `v<version>` tag 时发布。tag 必须匹配 `template.properties` 的版本。完整命令、凭据要求和自行发布示例见 [发布与市场数据](docs/publication-and-market.md)。

`latestRelease` 只记录实际已发布的独立版本。现有市场的旧包通过 `historicalRelease` 保留原下载地址和版本；独立 Release 登记后优先使用新包。当前尚未发布新的独立 Release。

## 索引与主题市场

| 文件 | 用途 |
| --- | --- |
| [catalog.sources.json](catalog.sources.json) | 登记主题 ID、配置 URL 和可选的数字市场 ID；这是接入索引的入口 |
| [catalog.json](catalog.json) | 从配置文件同步得到的主题目录，包含维护状态和归档记录 |
| [marketplace.json](marketplace.json) | 带 `schemaVersion` 的公共市场数据；通过 `installable` 判断是否提供安装入口 |
| [template.json](template.json) | 兼容旧 `List<Template>` 消费者的已发布主题列表；官网使用完整的 `marketplace.json` |

主题仓库更新配置后，在 `templates` 目录执行：

```bash
bin/theme catalog-sync
bin/theme catalog-check
bin/theme market-export --output marketplace.json --legacy-output template.json
```

审阅并提交这三个输出文件后，市场消费者再更新数据版本。也可以手动运行 GitHub Actions 的 **Refresh theme catalog**，下载生成的清单供审阅；该工作流不会自动提交或发布市场。

市场 ID 3 / 4 / 5 保持不变，Signal Notes 使用 6，Open Journal 使用 7。后两者尚未发布 Release，`installable=false`，只提供介绍和源码入口；归档 JSP 主题没有市场 ID。官网使用清单中的 `sourceUrl`，不再拼接旧聚合仓库地址。

`zrlog-www` 的配套适配使用 Java 同步和校验固定提交的 `marketplace.json`，将快照随官网代码审阅、提交和部署。清单更新不会直接改变线上市场；同步失败保留已有快照，官网按 `installable` 同时保护展示和安装请求。具体约定见 [消费契约](docs/publication-and-market.md#zrlog-www-消费契约)。

## 维护公共工具

```bash
./mvnw verify
bin/theme catalog-check
bin/theme check starter
```

修改预览实现时，还需运行目录和 ZIP 的真实渲染验证。历史提取方式、兼容修复及验证边界见 [迁移记录](docs/theme-migration.md)；Signal Notes 的详细试点验收见 [试点记录](docs/signal-notes-pilot.md)。
