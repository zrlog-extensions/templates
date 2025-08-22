<#include "header.ftl">
<section>
    <#if data??>
        <#if tipsType??>
            <h2 class="category-title">
                ${tipsType}目录：${tipsName}<br/>
                以下是与${tipsType} “${tipsName}” 相关联的文章
            </h2>
        </#if>
        <#list data.rows as log>
            <article>
                <#if log.thumbnail??>
                    <img class="thumbnail-img" alt="${log.thumbnailAlt}" src="${log.thumbnail}"/>
                </#if>
                <h1 class="post-title"><a rel="bookmark" href="${log.url}">${log.title}</a></h1>
                <div class="markdown-body">${log.digest}</div>
                <div class="meta" style="margin-top: .8em;margin-bottom: 0">
                    <p class="category">
                        <a rel="tag" style="margin-right: 3px" href="${log.typeUrl}">${log.typeName}</a>
                    </p>
                    <p class="published">/
                        <time style="margin-left: 3px">
                            ${log.releaseTime?split("T")[0]}
                        </time>
                    </p>
                    <p class="commentlink">
                        <a href="${log.url}#comment">
                            ${_res.commentView} <#if !staticBlog>[${log.commentSize}]</#if>
                        </a>
                    </p>
                </div>
            </article>
        </#list>
    <#else>
        <#include "404.ftl">
    </#if>
    <#include "pager.ftl">
</section>
<#include "plugin.ftl">
<#include "footer.ftl">
