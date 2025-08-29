<article>
    <h1 class="post-title">${log.title}</h1>
    <div class="meta">
        <p class="category">
            <a rel="tag" style="margin-right: 3px" href="${log.typeUrl}">${log.typeName}</a>
        </p>
        <p class="published">/
            <time style="margin-left: 3px">${log.releaseTime?split("T")[0]}</time>
        </p>
    </div>
    <div class="markdown-body">
        ${log.content}
    </div>
    <p style="color:#D4D4D4;padding-top: 20px;padding-bottom: 6px;">${_res.reprint}
        <a title="${log.title}" href="${log.url}"><span style="color: rgb(51, 102, 255);">${log.noSchemeUrl}</span></a>
    </p>
    <div class="pager-nav">
        <a title="${log.nextLog.title}" href="${log.nextLog.url}">
            <p class="next">${_res.nextArticle}：${log.nextLog.title}</p>
        </a>
        <a title="${log.lastLog.title}" href="${log.lastLog.url}">
            <p class="prev">${_res.lastArticle}：${log.lastLog.title}</p>
        </a>
    </div>
</article>
