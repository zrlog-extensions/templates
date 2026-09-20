<#include "header.ftl">
<h1>${(tipsName!webs.title!'')?html}</h1>
<#if _res['introText']?has_content><p>${_res['introText']?html}</p></#if>
<#if data?? && data.rows?has_content>
<#list data.rows as post>
<article>
<#if post.thumbnail?has_content><img class="cover" src="${post.thumbnail?html}" alt="${(post.thumbnailAlt!post.title)?html}"></#if>
<h2><a href="${post.url?html}">${post.title?html}</a></h2>
<p>${post.releaseTime?split("T")[0]} <#if post.typeUrl?has_content><a href="${post.typeUrl?html}">${(post.typeName!'')?html}</a></#if></p>
<div class="markdown-body">${post.digest!''}</div>
</article>
</#list>
<#else><p>${_res.empty!'No articles yet.'}</p></#if>
<#include "pager.ftl">
<#include "footer.ftl">
