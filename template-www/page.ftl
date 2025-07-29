<#include "header.ftl">
<section class="py-16 bg-gray-50 dark:bg-black">
    <div class="container mx-auto px-4 md:px-6">
        <div class="flex flex-col lg:flex-row gap-8">
            <main class="lg:w-3/4 w-full space-y-6">

                <#if data?has_content>
                    <#if tipsType?has_content>
                        <div class="bg-white dark:bg-gray-900 shadow rounded-lg p-6">
                            <h3 class="text-xl sm:text-2xl dark:text-gray-200 font-semibold text-gray-800 mb-2">${tipsType}目录：${tipsName}</h3>
                            <p class="text-gray-600 dark:text-gray-200 text-base">以下是与 ${tipsType} “${tipsName}” 相关联的文章</p>
                        </div>
                    </#if>

                    <#if data?has_content && data.rows?has_content>
                        <#list data.rows as log>
                            <article class="bg-white dark:text-gray-200 dark:bg-gray-900 shadow rounded-lg p-6 markdown-body space-y-4">

                                <#if log.thumbnail?has_content>
                                    <img
                                            class="w-full h-auto max-h-60 sm:max-h-80 object-cover rounded-lg border border-gray-200"
                                            onerror="this.style.display='none'"
                                            alt='${log.title}'
                                            src="${log.thumbnail}"
                                    />
                                </#if>

                                <h2 class="text-xl sm:text-2xl font-bold leading-snug">
                                    <a rel="bookmark" href="${log.url}" class="text-blue-600 dark:text-gray-200 hover:underline">
                                        ${log.title}
                                    </a>
                                </h2>

                                <div class="text-gray-700 text-base dark:text-gray-300">
                                    ${log.digest!''}
                                </div>

                                <div class="text-sm text-gray-500 flex flex-wrap justify-between items-center">
                                    <div class="flex items-center gap-2">
                    <span class="category">
                      <a href="${log.typeUrl}" class="text-blue-600 hover:underline"><i class="ri-folder-line"></i> ${log.typeName}</a>
                    </span>
                                        <span>/</span>
                                        <span><i class="ri-time-line"></i> ${log.releaseTime?split("T")[0]}</span>
                                    </div>

                                    <#if log.canComment>
                                        <a href="${log.url}#comment" class="text-blue-600 hover:underline">
                                            <i class="ri-chat-1-line"></i> ${_res.commentView} [${log.commentSize}]
                                        </a>
                                    </#if>
                                </div>
                            </article>
                        </#list>
                    </#if>
                <#else>
                    <#assign pageLevel = 1>
                    <#include "404.ftl">
                </#if>
            </main>
            <#include "plugin.ftl">
        </div>
        <#include "pager.ftl">
    </div>
</section>
<#include "footer.ftl">