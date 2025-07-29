<#include "header.ftl">
<#assign pageLevel = 1>
<div id="main">
    <#if log??>
        <div id="primary">
            <div id="content" role="main">
                <nav id="nav-single">
                    <h3 class="assistive-text">文章导航</h3>
                    <span class="nav-previous"><a href="${log.lastLog.url}"
                                                  title="${log.lastLog.title}" rel="prev"><span
                                    class="meta-nav">&larr;</span> 上一篇</a></span>
                    <span class="nav-next"><a href="${log.nextLog.url}"
                                              title="${log.nextLog.title}" rel="next">下一篇 <span class="meta-nav">&rarr;</span></a></span>
                </nav>
                <article class="post type-post status-publish format-standard hentry">
                    <header class="entry-header">
                        <h1 class="entry-title">${log.title}</h1>
                        <div class="entry-meta">
                            <span class="sep">发表于 </span><a href="${rurl}${log.alias}" rel="bookmark">
                                <time class="entry-date" datetime="${log.releaseTime}">
                                    ${log.releaseTime}
                                </time>
                            </a>
                        </div>
                    </header>
                    <div class="entry-content markdown-body">
                        ${log.content}
                    </div>
                    <br/>
                    <footer class="entry-meta">
                        此条目是由 ${log.userName} 发表在 <a title="查看${log.typeName}中的全部文章"
                                                             href="${rurl}sort/${log.typeAlias}"
                                                             rel="category tag">${log.typeName}</a>
                        分类目录的
                        <#if log.keywords?has_content>
                            ，并贴了
                            <#list log.keywords?split(",") as tag>
                                <a href="${rurl}tag/${tag}" rel="tag">${tag}</a>&nbsp;
                            </#list>
                            标签
                        </#if>
                    </footer>
                    <div id="copyinfo">
                        <p>
                            转载请注明作者和出处（${webs.title}），并添加本页链接<br>原文链接:
                            <a title="${log.title}" href="${rurl}${log.alias}">
                                <span style="color: rgb(51, 102, 255);">${rurl}${log.alias}</span>
                            </a>
                        </p>
                    </div>
                </article>
                <#include "comment.ftl">
            </div>
        </div>
    <#else>
        <#include "404.ftl">
    </#if>
</div>
<#include "plugs.ftl">
<#include "footer.ftl">
