<#include "header.ftl">
<#if log??>
    <#assign articleAuthor = log.userName!(webs.title!'')>
    <article class="article-shell shell">
        <div class="article-head">
            <a class="article-back" href="${baseUrl}"><span aria-hidden="true">&larr;</span>${_res.backToBlog!'Back to Blog'}</a>
            <time class="article-date" datetime="${log.releaseTime}">${log.releaseTime?split("T")[0]}</time>
            <h1 class="article-head__title">${log.title}</h1>
            <div class="article-authors">
                <span class="article-authors__label">${_res.postedBy!'Posted by'}</span>
                <a class="article-author" href="${baseUrl}">
                    <#if log.header?has_content>
                        <img class="article-author__avatar" src="${log.header}" alt="${articleAuthor}"/>
                    <#else>
                        <span class="article-author__avatar" aria-hidden="true"></span>
                    </#if>
                    <span>${articleAuthor}</span>
                </a>
                <#if log.typeName?has_content>
                    <#if log.typeUrl?has_content>
                    <a class="article-author article-author--category" href="${log.typeUrl}">
                        <span class="category-icon" aria-hidden="true"></span>
                        <span>${log.typeName!''}</span>
                    </a>
                    <#else>
                    <span class="article-author article-author--category">
                        <span class="category-icon" aria-hidden="true"></span>
                        <span>${log.typeName!''}</span>
                    </span>
                    </#if>
                </#if>
            </div>
        </div>

        <section class="article-layout">
            <#include "article.ftl">
            <#include "comment.ftl">
        </section>
    </article>
    <#include "plugin.ftl">
<#else>
    <#assign pageLevel = 1>
    <#include "404.ftl">
</#if>
<#include "footer.ftl">
