<div class="article-card">
    <div class="markdown-body article-body">${log.content!''}</div>

    <#if log.tags?has_content>
        <nav class="article-tags-wrap" aria-label="${_res.tag!'Tags'}">
            <span class="section-title section-title--inline">${_res.tag!'Tags'}</span>
            <div class="article-tags">
                <#list log.tags as tag>
                    <a class="article-tag" href="${tag.url}">#${tag.name}</a>
                </#list>
            </div>
        </nav>
    </#if>

    <div class="article-source">
        <span>${_res.reprint!'Permalink'}</span>
        <a href="${log.noSchemeUrl}" title="${log.title}">${log.noSchemeUrl}</a>
    </div>

    <#if _res.detailAd?has_content>
        <div class="article-slot">${_res.detailAd}</div>
    </#if>

    <#if (log.lastLog?? && log.lastLog.url?has_content) || (log.nextLog?? && log.nextLog.url?has_content)>
        <div class="article-nav">
            <#if log.lastLog?? && log.lastLog.url?has_content>
                <a class="article-nav__item" href="${log.lastLog.url}">
                    <span class="article-nav__label">${_res.lastArticle!'Previous post'}</span>
                    <strong>${log.lastLog.title}</strong>
                </a>
            </#if>
            <#if log.nextLog?? && log.nextLog.url?has_content>
                <a class="article-nav__item article-nav__item--next" href="${log.nextLog.url}">
                    <span class="article-nav__label">${_res.nextArticle!'Next post'}</span>
                    <strong>${log.nextLog.title}</strong>
                </a>
            </#if>
        </div>
    </#if>
</div>
