# templates 工作约定

- 本仓库是主题索引、公共规范、起步骨架和开发预览环境；新主题源码进入独立仓库。
- 先读 README、docs/theme-contract.md 和 preview/README.md。主题专属设计规则留在主题仓库。
- 运行时锁在 preview/runtime.lock.json；不得用 latest、浮动 SNAPSHOT 或本机 Maven 缓存替代。
- 不复制或改写 ZrLog 的模板引擎、路由和页面 DTO。PreviewApplication 只做安装、夹具注入和启动配置。
- 修改工具后执行 Maven/JUnit 测试、catalog-check 和 starter 检查。修改预览需对目录和 ZIP 跑真实渲染冒烟。
- 打包采用运行时文件允许列表；不得把 .git、环境配置、数据库、凭据、构建缓存放入 ZIP。
- 全部主题源码由独立仓库维护；保留历史市场 ID、版本和下载地址，不改变主题自身设计。
- 历史 JSP 主题集中在 templates-legacy-jsp，不再维护或发布；索引只登记归档配置，不得把配置校验当作当前 FreeMarker 运行时验收。
- 索引同步只能获取 catalog.sources.json 指向的主题配置；不能拉主题源码或发布包。构建上传在主题仓库/CI 调用公共工具执行。
- 公共市场清单是 zrlog-www 的消费接口。保留数字市场 ID，未发布主题不得生成安装链接，格式变化需更新 schemaVersion 和消费契约。
