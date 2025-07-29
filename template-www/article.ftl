<article class="bg-white dark:bg-gray-900 shadow rounded p-8">
    <!-- 标题 -->
    <h2 class="text-3xl font-bold border-b border-gray-200 pb-3 mb-6">${log.title}</h2>

    <!-- 分类与发布时间 -->
    <div class="flex items-center space-x-2 text-sm text-gray-500 mb-6">
    <span>
      <a class="text-blue-600 hover:underline" href="${log.typeUrl}" rel="tag">${log.typeName}</a>
    </span>
        <span>/</span>
        <span>${log.releaseTime?split("T")[0]}</span>
    </div>

    <!-- 正文内容，保留 markdown-body 类 -->
    <div class="pt-4 markdown-body">
        ${log.content!''}
    </div>

    <hr class="my-8 border-gray-300"/>

    <!-- 标签 -->
    <#if log.tags?has_content>
        <div class="flex flex-wrap items-center gap-3 mb-6">
            <#list log.tags as tag>
                <a class="text-blue-600 text-sm hover:underline bg-blue-50 px-2 py-1 rounded" href="${tag.url}">
                    #${tag.name}
                </a>
            </#list>
        </div>
    </#if>

    <!-- 转载说明 -->
    <p class="text-sm text-gray-500 mb-4">
        ${_res.reprint!''}
        <a class="text-blue-600 hover:underline pl-2" title="${log.title}" href="${log.noSchemeUrl}">
            ${log.noSchemeUrl}
        </a>
    </p>

    <!-- 上/下一篇 -->
    <div class="space-y-2 mb-6 text-sm">
        <p>
            <a title="${log.nextLog.title}" href="${log.nextLog.url}" class="hover:underline">
                ${_res.nextArticle}：
                <span class="text-blue-600">${log.nextLog.title}</span>
            </a>
        </p>
        <p>
            <a title="${log.lastLog.title}" href="${log.lastLog.url}" class="hover:underline">
                ${_res.lastArticle}：
                <span class="text-blue-600">${log.lastLog.title}</span>
            </a>
        </p>
    </div>

    <!-- 广告位 -->
    <div class="mt-6">
        ${_res.detailAd!''}
    </div>
</article>
