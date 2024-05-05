<aside>
    <div class="widget search">
        <form id="searchform" action="${searchUrl!}" method="post">
            <p class="search_input"><input type="text" placeholder="${_res.searchTip!}" size="15" name="key"
                                           value="${key!}" class="inputtext"><input type="submit" class="btn"
                                                                                    value="${_res.search!}"></p>
        </form>
    </div>
    <#if init.plugins??>
        <#list init.plugins as plugin>
            <#if plugin.isSystem == false>
            <#else>
                <#switch plugin.pluginName>
                    <#case "types">
                        <div class="widget">
                            <h3>${_res.category!}</h3>
                            <div class="list">
                                <ul class="category_list">
                                    <#list init.types as type>
                                        <li><a href="${type.url}">${type.typeName} (${type.typeamount})</a></li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                        <#break>
                    <#case "links">
                        <div class="widget">
                            <h3>${_res.link!}</h3>
                            <ul>
                                <#list init.links as link>
                                    <li><a href="${link.url}" title="${link.alt}"
                                           target="_blank">${link.linkName}</a></li>
                                </#list>
                            </ul>
                        </div>
                        <#break>
                    <#case "archives">
                        <div class="widget">
                            <h3>${_res.archive!}</h3>
                            <ul>
                                <#list init.archiveList as archive>
                                    <li><a href="${archive.url}">${archive.text} (${archive.count})</a></li>
                                </#list>
                            </ul>
                        </div>
                        <#break>
                    <#case "tags">
                        <div class="widget">
                            <h3>${_res.tag!}</h3>
                            <div class="taglist" id="tags">
                                <#list init.tags as tag>
                                    <a href="${tag.url}" title="${tag.text}上共有(${tag.count})文章">${tag.text}</a>
                                </#list>
                            </div>
                        </div>
                        <#break>
                </#switch>
            </#if>
        </#list>
    </#if>
</aside>
