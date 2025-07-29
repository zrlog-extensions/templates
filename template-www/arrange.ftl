<#include "header.ftl">
<style>
    .arranger-article {
        max-width: 1154px !important;
        border-radius: 8px;
        padding: 24px !important;
    }

    .arranger-outline {
        width: 300px !important;
    }

    .arranger-title {
        font-size: 28px;
        padding-bottom: 8px;
        font-weight: 500;
        line-height: 48px;
    }
    .arranger-content {
        padding-top: 24px !important;
    }

    .arranger-outline ul li {
        border-radius: 8px !important;
    }
</style>
<section class="py-16 bg-gray-50 dark:bg-black">
    <div class="container bg-white dark:bg-gray-900 mx-auto rounded md:p-8 sm:p-4">
        <plugin name="${arrangePlugin}" view="${reqUriPath}" param="${reqQueryString}"/>
    </div>
</section>
<#include "footer.ftl">
