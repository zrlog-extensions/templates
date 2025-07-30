<#include "header.ftl">
<section>
    <#if log?has_content>
        <#include "article.ftl">
        <#include "comment.ftl">
    <#else>
        <#include "404.ftl">
    </#if>
</section>
<#include "plugin.ftl">
<#include "footer.ftl">