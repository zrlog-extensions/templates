<#if log.canComment>
    <section id="comment" class="comment-box">
        <h2 class="section-title">${_res.comment!'Comments'}</h2>
        <plugin name="${website.comment_plugin_name}" view="widget" param="articleId=${log.logId}"/>
    </section>
</#if>
