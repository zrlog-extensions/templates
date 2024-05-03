<#include "header.ftl">
<div class="content-wrap">
    <div id="content" class="content">
        <#if log??>
            <#include "article.ftl">
        <#else>
            <#assign pageLevel = 1>
            <#include "404.ftl">
        </#if>
    </div>
</div>
<#include "footer.ftl">