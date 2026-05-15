<section class="discovery shell" aria-labelledby="discovery-title">
    <div class="discovery-grid">
        <section class="discovery-card discovery-card--search">
            <h2 id="discovery-title">${_res.moreStories!'More stories'}</h2>
            <p class="discovery-card__desc">${_res.sidebarTitle!'Discover more'}</p>
            <form class="discovery-search" action="${searchUrl}" method="post">
                <input name="key" type="text" placeholder="${_res.searchTip!'Search articles'}" value="${key!''}"/>
                <button type="submit">${_res.search!'Search'}</button>
            </form>
        </section>

        <#if init.types?has_content>
            <section class="discovery-card">
                <h3>${_res.category!'Category'}</h3>
                <ul class="discovery-list">
                    <#list init.types as type>
                        <li><a href="${type.url}"><span>${type.typeName}</span><em>${type.typeamount}</em></a></li>
                    </#list>
                </ul>
            </section>
        </#if>

        <#if init.archiveList?has_content>
            <section class="discovery-card">
                <h3>${_res.archive!'Archive'}</h3>
                <ul class="discovery-list">
                    <#list init.archiveList as archive>
                        <li><a href="${archive.url}"><span>${archive.text}</span><em>${archive.count}</em></a></li>
                    </#list>
                </ul>
            </section>
        </#if>

        <#if init.tags?has_content>
            <section class="discovery-card">
                <h3>${_res.tag!'Tags'}</h3>
                <div class="tag-cloud">
                    <#list init.tags as tag>
                        <a class="tag-chip" href="${tag.url}">${tag.text}</a>
                    </#list>
                </div>
            </section>
        </#if>

        <#if init.links?has_content>
            <section class="discovery-card">
                <h3>${_res.link!'Elsewhere'}</h3>
                <ul class="discovery-list">
                    <#list init.links as link>
                        <li><a href="${link.url}" title="${link.alt}" target="_blank"><span>${link.linkName}</span></a></li>
                    </#list>
                </ul>
            </section>
        </#if>

        <#if _res.widgetAd?has_content>
            <section class="discovery-card discovery-card--ad">${_res.widgetAd}</section>
        </#if>
    </div>
</section>
