<#if pager?has_content>
<nav class="pagination">
	<#list pager.pageList as page>
	<a class="page-number ${page.current?then('current','')}" href="${page.url}">
		${page.desc}
	</a>
</#list>
</nav>
</#if>