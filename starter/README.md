# ZrLog theme starter

本目录是可运行的起步骨架。创建独立主题后，更新 template.properties 和 theme.json 中的作者、名称、来源、简介、日期、版本与发布方式，补充自己的设计说明与真实预览图。不要将示例 URL 登记到市场。

```bash
../templates/bin/theme check .
../templates/bin/theme preview .
../templates/bin/theme package . --output dist/template-my-theme.zip
```

目录名和 ZIP 名应匹配你的 theme ID。交付前按 templates/docs/development.md 完成真实渲染、移动端和 ZIP 安装验收。
