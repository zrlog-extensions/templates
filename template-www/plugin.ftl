<aside class="lg:w-1/4 w-full space-y-6">
    <#-- 广告位 -->
    <#if _res.widgetAd?has_content>
        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-4">
            ${_res.widgetAd}
        </div>
    </#if>

    <#-- 搜索框 -->
    <form action="${searchUrl}" method="post" class="bg-white dark:bg-gray-900 shadow rounded-lg p-4 space-y-3">
        <h3 class="text-lg font-semibold text-gray-700">${_res.search}</h3>
        <div class="flex items-center space-x-2">
            <input
                    type="text"
                    name="key"
                    value="${key!""}"
                    placeholder="${_res.searchTip}"
                    class="flex-1 border border-gray-300 rounded px-3 py-2 text-sm focus:ring focus:ring-primary focus:outline-none"
            />
            <button
                    type="submit"
                    class="bg-primary text-white text-sm font-medium px-4 py-2 rounded hover:bg-primary-700 cursor-pointer"
            ><i class="ri-search-line"></i> ${_res.search}</button>
        </div>
    </form>

    <#-- 插件内容 -->
    <#if init.plugins?has_content>
        <#list init.plugins as plugin>
            <#if plugin.isSystem == false>
            <#-- 跳过非系统插件 -->
            <#else>
                <#switch plugin.pluginName>

                    <#case "types">
                        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-700 mb-2">${_res.category}</h3>
                            <ul class="space-y-1 text-sm text-gray-600">
                                <#list init.types as type>
                                    <li>
                                        <a class="text-primary hover:underline" href="${type.url}">
                                            <i class="ri-folder-line"></i> ${type.typeName} (${type.typeamount})
                                        </a>
                                    </li>
                                </#list>
                            </ul>
                        </div>
                        <#break>

                    <#case "links">
                        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-700 mb-2">${_res.link}</h3>
                            <ul class="space-y-1 text-sm text-gray-600">
                                <#list init.links as link>
                                    <li>
                                        <a class="text-primary hover:underline" href="${link.url}" title="${link.alt}" target="_blank">
                                            <i class="ri-link"></i> ${link.linkName}
                                        </a>
                                    </li>
                                </#list>
                            </ul>
                        </div>
                        <#break>

                    <#case "archives">
                        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-700 mb-2">${_res.archive}</h3>
                            <ul class="space-y-1 text-sm text-gray-600">
                                <#list init.archiveList as archive>
                                    <li>
                                        <a class="text-primary hover:underline" href="${archive.url}" rel="nofollow">
                                            <i class="ri-archive-line"></i>  ${archive.text} (${archive.count})
                                        </a>
                                    </li>
                                </#list>
                            </ul>
                        </div>
                        <#break>

                    <#case "tags">
                        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-700 mb-2">${_res.tag}</h3>
                            <div class="flex flex-wrap gap-2 text-sm">
                                <#list init.tags as tag>
                                    <a class="text-primary hover:underline bg-blue-50 px-2 py-1 rounded" href="${tag.url}">
                                         <i class="ri-chat-thread-line"></i> ${tag.text}
                                    </a>
                                </#list>
                            </div>
                        </div>
                        <#break>

                </#switch>
            </#if>
        </#list>
    </#if>
</aside>
