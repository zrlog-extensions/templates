<#if pager??>
    <nav class="pagination-wrap">
        <#if !pager.startPage>
            <a class="pagination-link" href="${pager.pageStartUrl}">${_res.pageStart!'First'}</a>
        </#if>
        <div class="pagination-list">
            <#list pager.pageList as page>
                <a class="pagination-link<#if page.current> is-current</#if>" href="${page.url}">${page.desc}</a>
            </#list>
        </div>
        <#if !pager.endPage>
            <a class="pagination-link" href="${pager.pageEndUrl}">${_res.pageEnd!'Next'}</a>
        </#if>
    </nav>
</#if>
