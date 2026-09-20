<#if log.canComment && webs.comment_plugin_name?has_content>
<section id="comment"><plugin name="${webs.comment_plugin_name}" view="widget" param="articleId=${log.logId}"/></section>
</#if>
