# 主题创建与验收

## AI 工作顺序

1. 明确主题 ID、目标读者、视觉参考、首页/详情布局、配色、可配置项，将这些写入主题自身设计说明。
2. 用 `bin/theme init ../template-name` 创建独立目录，再初始化 Git 仓库。
3. 阅读公共字段规范和主题设计说明，完成数据驱动页面。不要写死预览内容或把虚构字段当接口。
4. 运行 check；修改 JS 后运行 `node --check`。check 验证包结构与字面 include，不承诺完整 FTL 语法或 CSS 正确。
5. 用真实预览环境访问页面，修复模板错误、资源缺失和交互问题。
6. package 后再次预览 ZIP，确认正式安装器解压后的页面与目录预览一致。
7. 保存截图、基准版本、命令结果；在主题仓库发布，再更新索引。

## 固定验收内容

`preview/fixtures` 的版本由 runtime.lock.json 中 fixtureVersion 标识。内容覆盖五篇文章、分页、长标题、无封面、多年月、分类、标签、友链、代码、表格、图片和评论开关。

```bash
bin/theme preview ../template-signal-notes --port 7080
bin/theme smoke --base-url http://127.0.0.1:7080
```

基准路由：首页 `/`，分页 `/all-2`，详情 `/writing-on-my-own-site`，无封面/关闭评论 `/notes-from-the-past`，分类 `/sort/notes`，标签 `/tag/ZrLog`，月份 `/record/2026_07`，搜索 `/search?key=ZrLog`，404 `/does-not-exist`。

- 桌面 1440×1000、移动 390×844：首页、详情、404；检查导航、搜索、分页、正文与横向溢出。
- 支持明暗模式的主题检查切换、持久化，以及正文/代码样式跟随。
- `--empty`：无文章、分类、标签、友链时仍能返回可用页面。
- `--comments empty`：插件无内容时页面不能报错；默认 fixture 只验证评论容器。
- `--settings path.json`：确认配置进入真实 `_res`。配置定义和值变更需重启预览。
- 包内所有图片和 JS/CSS 应可加载。共享 CSS/font 请求也必须无 404。

`bin/theme smoke` 检查真实路由状态、完整 HTML 外壳和页面引用资源；交互、截图与视觉判断需要浏览器验收。版本发布兼容范围不得超出已验证版本。

## 安装包

```bash
bin/theme package ../template-signal-notes --output dist/template-signal-notes.zip
bin/theme preview dist/template-signal-notes.zip --port 7081
bin/theme smoke --base-url http://127.0.0.1:7081
```

ZIP 根目录直接包含 template.properties；不包含外层源码仓库目录。相同源码重复打包应得到相同 SHA-256。
