<#include "header.ftl">
<section class="blog-root shell">
    <section class="hero">
        <h1 class="hero__title">
            <#if tipsType?has_content>
                <#if tipsName?has_content>${tipsName}<#else>${tipsType}</#if>
            <#else>
                ${_res.latestArticles!'The latest Next.js news'}
            </#if>
        </h1>
        <#if tipsType?has_content || (_res['introText']?has_content)>
            <p class="hero__desc">
                <#if tipsType?has_content>
                    <#if tipsType == (_res.searchSummary!tipsType)>
                        ${_res.searchSummary!tipsType}: ${tipsName}
                    <#else>
                        ${tipsType}: ${tipsName}
                    </#if>
                <#else>
                    ${_res['introText']}
                </#if>
            </p>
        </#if>
    </section>

    <section class="posts-grid">
        <#if data?? && data.rows?has_content>
            <#list data.rows as log>
                <article class="post-card">
                    <#if log.thumbnail?has_content>
                        <a class="post-card__media" href="${log.url}" aria-label="${log.title}">
                            <img src="${log.thumbnail}" alt="${log.thumbnailAlt!log.title}" loading="lazy" onerror="this.closest('.post-card__media').style.display='none'"/>
                        </a>
                    </#if>
                    <div class="post-card__inner">
                        <div class="post-card__meta">
                            <div class="post-card__meta-main">
                                <p class="post-card__date">${log.releaseTime?split("T")[0]}</p>
                                <#if log.typeName?has_content>
                                    <#if log.typeUrl?has_content>
                                        <a class="post-card__category" href="${log.typeUrl}">
                                            <span class="category-icon" aria-hidden="true"></span>
                                            <span>${log.typeName}</span>
                                        </a>
                                    <#else>
                                        <span class="post-card__category">
                                            <span class="category-icon" aria-hidden="true"></span>
                                            <span>${log.typeName}</span>
                                        </span>
                                    </#if>
                                </#if>
                            </div>
                            <div class="post-card__authors" aria-label="${log.typeName!''}">
                                <#if log.header?has_content>
                                    <img class="post-card__author" src="${log.header}" alt="${log.userName!(webs.title!'')}"/>
                                <#else>
                                    <span class="post-card__author" aria-hidden="true"></span>
                                </#if>
                                <#if log.recommended?? && log.recommended>
                                    <span class="post-card__more">+1</span>
                                </#if>
                            </div>
                        </div>

                        <a class="post-card__title" href="${log.url}">${log.title}</a>
                        <div class="markdown-body post-card__prose">${log.digest!''}</div>
                    </div>
                    <a class="post-card__read-more" href="${log.url}">${_res.readArticle!'Read More'}</a>
                </article>
            </#list>
        <#else>
            <#assign pageLevel = 1>
            <#include "404.ftl">
        </#if>
    </section>

    <#include "pager.ftl">
</section>
<#include "footer.ftl">
