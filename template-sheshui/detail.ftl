<#include "header.ftl">
<section>
    <#if log?has_content>
    <div style="background:rgba(255,255,255,1);">
        <#include "article.ftl">
        <#include "comment.ftl">
    </div>
    <#else>
    <#include "404.ftl">
</#if>
</section>
<#include "plugin.ftl">
<#include "footer.ftl">