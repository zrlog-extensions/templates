# 独立主题发布与主题市场数据

## 三方职责

- 主题仓库维护源码、theme.json、设计文档和版本。
- templates 提供 Java 通用构建/发布工具及可复用 GitHub Actions，索引同步只获取配置文件。
- zrlog-www 消费 templates 导出的市场清单，不读取主题源码，不根据目录猜下载地址。

构建发生在主题仓库或其 CI 的检出目录中。索引同步命令 `catalog-sync` 只访问 catalog.sources.json 声明的 configUrl，不 clone 主题，不拉取 ZIP，也不执行主题代码。

## 主题配置 theme.json

Signal Notes 的 theme.json 是完整示例，关键字段如下：

| 字段 | 含义 |
| --- | --- |
| schemaVersion | 配置结构版本，目前为 1 |
| id | 稳定主题 ID，如 template-signal-notes |
| name、author、description、tags、en | 市场展示文案与英文内容 |
| repository、preview、createdDate | 源码地址、预览图 HTTPS 地址、首次登记日期 |
| engine、testedRuntime | freemarker 或 jsp；实际验证过的 ZrLog 版本，未验证时为 null |
| sourceDirectory | 相对主题仓库的运行文件目录，不能越出仓库 |
| distribution | 发布方式，见下文 |
| latestRelease | 已发布版本的 tag、URL、SHA-256；未发布时为 null |
| historicalRelease | 迁移前已有市场包的 tag、URL；保留原版本和下载地址，没有已知校验值时不填写 SHA-256 |

全局数字 marketplaceId 由 templates 的 catalog.sources.json 分配，主题作者不能自行覆盖。现有市场 ID 3、4、5 保持不变，Signal Notes 预留 6。

未在市场上架的历史主题可以不分配 marketplaceId；其配置仍进入 catalog.json，但不会进入市场清单。JSP 主题允许登记配置和自行维护 Release，公共构建/预览仅支持 FreeMarker。`descriptor-check theme.json` 只检查配置，不代表通过运行验证；JSP 仓库可以调用 `theme-config.yml@<完整 SHA>`。

## 方式一：公共构建与上传

配置 `distribution.mode=shared`，选择 target：

- `github-release`：调用 gh，创建 GitHub Release，上传 ZIP、SHA-256 和完整 theme.json。
- `s3`：调用 AWS CLI，上传版本目录中的 ZIP/SHA-256，最后更新稳定地址的 theme.json。publicBaseUrl 指向 keyPrefix 对应的公共下载目录；默认 keyPrefix 为 attachment/template。凭据通过 AWS 环境变量提供，配置文件不得包含密钥。

```bash
# 在主题仓库或其 CI 执行
../templates/bin/theme build . --output-dir dist
# 构建发布包和配置，先审阅，不上传
../templates/bin/theme publish . --tag v1.0 --output-dir dist --dry-run
# tag 已推送、验收通过后执行上传
../templates/bin/theme publish . --tag v1.0 --output-dir dist
```

发布 tag 去掉 v 后必须与 template.properties 的 version 相同。主题 CI 可以调用 `.github/workflows/theme-release.yml@<完整提交 SHA>`，toolkit-ref 使用相同 SHA；公共 workflow 在 PR/普通 push 只构建验收，在明确的版本 tag push 才上传。

S3 方式需配置 `ZRLOG_THEME_S3_BUCKET`、`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`，兼容 R2 等服务时提供 `AWS_ENDPOINT_URL` 和区域。通用上传不会写用户的全局 AWS 配置。

发布生成的配置文件地址：

- GitHub：`https://github.com/<owner>/<repo>/releases/latest/download/theme.json`
- S3：`<publicBaseUrl>/<theme-id>/theme.json`

## 方式二：自行维护 Release

配置 `distribution.mode=release`。主题可以自行构建 ZIP、维护 CI 和 Release，不需要使用通用发布器，只需提供符合约定的配置文件。

可用 Java 工具从已有 ZIP 生成带校验值的发布配置：

```bash
../templates/bin/theme release-config theme.json \
  --archive dist/template-example.zip --tag v1.0 \
  --url https://github.com/example/template-example/releases/download/v1.0/template-example.zip \
  --output dist/theme.json
```

自行上传 ZIP 和 theme.json，然后将配置文件的稳定 HTTPS 地址登记到 catalog.sources.json。也可在主题仓库固定路径维护配置，只要 latestRelease 指向真实发布包。

## 索引更新

```bash
bin/theme catalog-sync
bin/theme catalog-check
bin/theme market-export --output marketplace.json --legacy-output template.json
```

所有配置校验通过后才更新 catalog.json。迁移期间可用 `catalog-sync --local ../template-signal-notes/theme.json` 先验证尚未发布的配置。

Signal Notes 首次独立 Release 尚未发布，当前 configUrl 指向 main/theme.json，latestRelease 为 null；首次发布后改为 Release 中的 theme.json 地址，或由主题维护者更新 main 的发布信息。不能把 dry-run 生成的配置当成已经发布。

## zrlog-www 消费契约

- `marketplace.json`：带 schemaVersion 的公共数据，包含已发布和未发布条目，用 status / installable 区分。消费者只对 installable=true 展示安装操作。
- `template.json`：仅已发布主题的数组，兼容目前 zrlog-www 的 `List<Template>`。保留数字 id、name、desc、author、image、version、downloadUrl、fileName、sourceUrl、tags 和 en。
- 新清单额外提供 themeId、sha256、engine、testedRuntime。构建路径和上传配置不会进入市场清单。
- 旧市场的三个主题通过 historicalRelease 沿用原下载地址；其历史配置没有 SHA-256，不伪造校验值。独立 Release 发布后，latestRelease 必须提供真实 SHA-256，并优先于 historicalRelease。历史市场版本不一定等于当前源码 template.properties 的 version，不能用历史标签给新包定版本。
- 下载统计、推荐排序属于市场自身数据，不由主题作者申报。

官网接入时固定 templates 的提交或发布版本，把兼容清单作为构建资源；校验失败应使构建失败并保留上一份已部署市场。升级 schemaVersion 需要同步消费者。

当前 zrlog-www 的 TemplateController 会硬编码覆盖 sourceUrl 为旧聚合仓库地址。接入时应改为使用清单提供的 sourceUrl，否则独立主题详情会指向错误仓库。本试点提供消费数据和契约，官网接入可单独完成。
