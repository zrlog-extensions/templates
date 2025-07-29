<#include "header.ftl">
<section class="py-16 bg-gray-50 dark:bg-black">
    <div class="container mx-auto px-4 md:px-6">
        <div class="flex flex-col lg:flex-row gap-8">
            <main class="lg:w-2/3 w-full">
                <#if log??>
                    <#include "article.ftl">
                    <#include "comment.ftl">
                <#else>
                    <#assign pageLevel = 1>
                    <#include "404.ftl">
                </#if>
            </main>
            <#include "plugin.ftl">
        </div>
    </div>
</section>
<#include "footer.ftl">
