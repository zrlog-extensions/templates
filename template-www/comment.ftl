<#if log.canComment>
    <div id="comment" class="mt-10 bg-white dark:bg-gray-900 p-6 rounded shadow space-y-4">
        <plugin name="${website.comment_plugin_name}" view="widget" param="articleId=${log.logId}"/>
    </div>
</#if>