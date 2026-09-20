# ZrLog 主题索引与开发环境

本仓库负责主题索引、基础规范、最小骨架和统一预览环境。具体主题在独立仓库开发、版本化和发布。

首个试点：[Signal Notes](https://github.com/zrlog-extensions/template-signal-notes)。机器可读索引见 [catalog.json](catalog.json)。

## 开始开发

需要 JDK 17+；通过 Maven Wrapper 构建公共工具，无需 Docker 或外部数据库。

```bash
git clone https://github.com/zrlog-extensions/templates.git
git clone https://github.com/zrlog-extensions/template-signal-notes.git
cd templates
./mvnw verify
bin/theme check ../template-signal-notes
bin/theme preview ../template-signal-notes
```

访问 http://127.0.0.1:7080。首次运行从官方地址下载固定的 **ZrLog 3.9.2** 并检查 SHA-256。每次启动通过真实安装链路创建独立 SQLite 数据库，载入统一内容；退出后清理临时站点。

```bash
# 创建自己的主题目录，再在目录内 git init
bin/theme init ../template-my-theme
# 制作安装包并走真实 ZIP 安装链路验证
bin/theme package ../template-signal-notes --output dist/template-signal-notes.zip
bin/theme preview dist/template-signal-notes.zip --port 7081
# 检查正在运行的预览站点
bin/theme smoke --base-url http://127.0.0.1:7081
```

## 规范与职责

- [主题基础规范](docs/theme-contract.md)：目录、字段、配置和交付约定。
- [开发与验收](docs/development.md)：AI 工作流、固定场景、配置与空态检查。
- [基准运行环境](preview/README.md)：版本锁、运行方式和边界。
- [试点迁移记录](docs/signal-notes-pilot.md)：仓库关系及验证结果。
- [发布与市场数据](docs/publication-and-market.md)：公共构建上传、自行维护 Release、仅配置同步和 zrlog-www 消费契约。

## 发布与主题市场

主题仓库可以调用公共 `bin/theme build` / `publish` 和可复用 GitHub Actions，也可以自行维护 Release 包。两种方式都提供 theme.json；templates 的索引同步只拉对应配置文件。

```bash
bin/theme catalog-sync
bin/theme market-export --output marketplace.json --legacy-output template.json
```

marketplace.json 是版本化市场数据；template.json 为 zrlog-www 当前格式的已发布主题列表。未发布主题保留展示元信息，但没有安装入口。

`starter/` 是最小起步骨架，不是已发布主题。`preview/` 仅负责安装、内容注入和开发启动；路由、模板引擎、页面对象与静态资源处理全部来自官方发布包。

## 迁移状态

Signal Notes 已从这里提取，保留原主题提交历史。其他 `template-*` 目录在索引中标记为 `legacy`，暂保留原有分发以兼容已有用户；新主题必须建立独立仓库。`bin/package.sh` / `sync.yml` 仅用于这些尚未迁移的历史主题，已经排除 Signal Notes。

主题源码、版本和 ZIP 的唯一发布来源是其自身仓库。索引中的 `latestRelease` 在实际发布后填写 tag、下载地址和 SHA-256；空值表示尚未登记独立发布，不从旧 CDN 冒充新 Release。

## 工具验证

```bash
./mvnw verify
bin/theme catalog-check
bin/theme check starter
```
