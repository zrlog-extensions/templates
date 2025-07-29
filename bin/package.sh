#!/bin/bash
# 定义模板数组
templates=("template-simple" "template-sheshui" "template-hexo-theme-next" "template-www")

# 循环处理每个模板
for template in "${templates[@]}"
do
    cd $template
    echo "正在压缩 $template ..."
    zip -9 -r "../zip/attachment/template/${template}.zip" .
    cd ..
done

echo "所有模板已成功压缩。"