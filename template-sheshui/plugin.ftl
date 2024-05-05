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
    <#if plugin.isSystem == false && pageLevel >= plugin.level>
    <div class="widget">
        <h3>${plugin.pTitle}</h3>
        <p>${plugin.content}</p>
        <br/>
    </div>
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
<#case "archives">
<div class="widget">
    <h3>${_res.archive!}</h3>
    <ul>
        <#list init.archiveList as archive>
        <li><a href="${archive.url}">${archive.text} (${archive.count})</a></li>
    </#list>
    </ul>
</div>
<#case "tags">
<div class="widget">
    <h3>${_res.tag!}</h3>
    <div class="taglist" id="tags">
        <#list init.tags as tag>
        <a href="${tag.url}" title="${tag.text}上共有(${tag.count})文章">${tag.text}</a>
    </#list>
</div>
</div>
</#switch>
</#if>
</#list>
</#if>
</aside>
