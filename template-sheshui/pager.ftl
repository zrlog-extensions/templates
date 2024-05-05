<#if pager??>
<div class="page_navi">
    <#if !pager.startPage>
    <a title="${_res.pageStart}" class="extend" href="${pager.pageStartUrl}">${_res.pageStart}</a>
</#if>
<#list pager.pageList as page>
<a <#if page.current>class="current"</#if> href="${page.url}">${page.desc}</a>
</#list>
<#if !pager.endPage>
<a title="${_res.pageEnd}" class="extend" href="${pager.pageEndUrl}">${_res.pageEnd}</a>
</#if>
<div class="breadcrumb"></div>
</div>
</#if>
