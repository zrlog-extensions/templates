# zrlog-templates

这个仓库为 ZrLog 为官方提供的主题的，如果需要自己定制主题，参考 default 目录，目前 zrlog 编写主题支持 jsp/freemarker

参考文章 ： https://blog.zrlog.com/make-theme-for-zrlog.html

## 如何 include 插件提供页面

```
<plugin name="pluginName" view="page" param="articleId=${log.logId}"></plugin>
```

这种方式是支持所有的模板的，想了解实现方式可以查看 

https://github.com/94fzb/zrlog/blob/master/blog-web/src/main/java/com/zrlog/blog/web/interceptor/ResponseRenderPrintWriter.java

用途，比如评论框，打赏插件，相关文章推荐等

## 一起完善

提交 issues， 或者是发起 PR

## Unix

可以使用软链接的方式，将该工程 zrlog 的 include/templates ，进行开发定制