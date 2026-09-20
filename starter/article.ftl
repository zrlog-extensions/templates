<div class="markdown-body">${log.content!''}</div>
<#if log.tags?has_content><p><#list log.tags as tag><a href="${tag.url?html}">#${tag.name?html}</a> </#list></p></#if>
<nav>
<#if log.lastLog??><a href="${log.lastLog.url?html}">${log.lastLog.title?html}</a></#if>
<#if log.nextLog??><a href="${log.nextLog.url?html}">${log.nextLog.title?html}</a></#if>
</nav>
