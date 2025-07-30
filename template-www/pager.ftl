<#if pager??>
    <nav aria-label="Pagination" class="my-10">
        <ul class="inline-flex -space-x-px text-base ">

            <#-- 首页按钮 -->
            <#if !pager.startPage>
                <li>
                    <a href="${pager.pageStartUrl}" title="${_res.pageStart}"
                       class="dark:bg-gray-900 dark:text-gray-200 px-4 py-2 ml-0 leading-tight text-primary bg-white border border-gray-300 rounded-l-lg hover:bg-blue-100 hover:text-blue-700 transition">
                        ${_res.pageStart}
                    </a>
                </li>
            </#if>

            <#-- 页码列表（处理边界圆角） -->
            <#list pager.pageList as page>
                <li>
                    <a href="${page.url}"
                       class="dark:bg-gray-900 dark:text-gray-200 px-4 py-2 border border-gray-300 transition
               <#if page.current>
                 bg-primary text-white font-semibold cursor-default
               <#else>
                 bg-white text-gray-700 hover:bg-blue-100 hover:text-blue-700
               </#if>
               <#if pager.startPage && page?index == 0> rounded-l-lg </#if>
               <#if pager.endPage && page?index == (pager.pageList?size - 1)> rounded-r-lg </#if>">
                        ${page.desc}
                    </a>
                </li>
            </#list>

            <#-- 末页按钮 -->
            <#if !pager.endPage>
                <li>
                    <a href="${pager.pageEndUrl}" title="${_res.pageEnd}"
                       class="dark:bg-gray-900 dark:text-gray-200 px-4 py-2 leading-tight text-primary bg-white border border-gray-300 rounded-r-lg hover:bg-blue-100 hover:text-blue-700 transition">
                        ${_res.pageEnd}
                    </a>
                </li>
            </#if>

        </ul>
    </nav>
</#if>
