# Signal Notes 独立主题试点

## 结构

- 索引/规范/Java 工具：zrlog-extensions/templates。
- 主题源码与发布：zrlog-extensions/template-signal-notes。
- 从原仓库 fd28a514fae4246b87b7dd38f45a7cc8f274e88d 提取 template-signal-notes 子目录历史，导入提交 f8f1b882340d250945de66ee3d8d9a79924a647f。
- 主题 ID、配置键和 localStorage 键保持不变；原设计规则移至主题仓库 docs/design.md。
- 其余 3 个 FreeMarker 主题后续也已拆仓，4 个旧 JSP 主题集中归档并停止维护；原市场下载地址和 ID 继续保留，见 theme-migration.md。

## 基准与验证

运行时：官方 ZrLog 3.9.2 Java ZIP，源码提交 6f77e27c42f28580731691194076d0aaa7052b67；SHA-256 见 preview/runtime.lock.json。

本地构建使用 OpenJDK 25，工具以 Java 17 为目标编译；GitHub Actions 使用 JDK 17。

- Maven/JUnit：包内容允许列表、可复现 ZIP、配置结构、include、符号链接、ZIP 路径、同步增删改、运行时校验、发布配置绑定、索引及市场输出。
- Signal Notes 和 starter 均通过目录预览、真实 ZIP 安装后的双语页面与资源检查。
- Signal Notes 覆盖空内容、自定义配置、评论固定片段和空结果。
- Chrome 桌面 1440×1000、移动 390×844：首页、详情、空页面、明暗切换与持久化；未发现横向溢出或浏览器错误。
- 固定内容包含长标题、无封面、分页、多年月、代码、表格、图片和公式。

可重复运行：

```bash
./mvnw verify
bin/theme catalog-check
bash bin/verify-preview.sh ../template-signal-notes 17081
bin/theme init /tmp/template-starter
bash bin/verify-preview.sh /tmp/template-starter 17082
```

HTTP 验收输出保存在 target/preview-check；浏览器截图属于本地验收证据，主题 images/preview.jpg 为真实运行环境截图。

## 发布与市场

Signal Notes 试点采用共享 GitHub Release 发布器；公共工具同时提供 S3 上传和自行维护 Release 配置的入口。索引只读取 theme.json，见 publication-and-market.md。

独立 Release 未发布前，市场条目为 unreleased / installable=false；不声明可用下载包。共享上传流程仅在显式版本 tag push 时执行，试点验证不向 CDN 上传。

## 已知边界

- 基准 3.9.2 对不存在文章返回空页面及 HTTP 200，已记录在锁文件。
- 预览评论为固定片段，未验证实际评论插件的交互；没有管理后台。
- S3 上传需要真实目标及凭据，试点未向任何 S3/CDN 发布。
- zrlog-www 尚未切换数据源；已生成兼容清单，并记录其 sourceUrl 硬编码需要调整。
