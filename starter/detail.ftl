<#include "header.ftl">
<#if log??>
<article>
<h1>${log.title?html}</h1>
<p>${log.releaseTime?split("T")[0]}</p>
<#include "article.ftl">
</article>
<#include "comment.ftl">
</#if>
<#include "footer.ftl">
