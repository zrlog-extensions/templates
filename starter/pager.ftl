<#if pager??>
<nav aria-label="${(_res.pagination!'Pages')?html}">
<#list pager.pageList as page><a href="${page.url?html}"<#if page.current> aria-current="page"</#if>>${page.desc?html}</a></#list>
</nav>
</#if>
