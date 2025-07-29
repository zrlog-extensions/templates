<!-- 返回顶部按钮 -->
<button
        id="back-to-top"
        class="fixed bottom-6 right-6 w-12 h-12 bg-primary text-white rounded-full shadow-lg flex items-center justify-center opacity-0 invisible transition-all duration-300"
>
    <i class="ri-arrow-up-line text-xl"></i>
</button>
<footer class="bg-gray-900 text-white py-12" id="footer">
    <div class="container mx-auto px-4 md:px-6">
        ${_res['footerLinkExt']!''}
        <div class="border-t border-gray-800 pt-8 flex flex-col md:flex-row justify-between items-center">
            <div class="text-gray-400 mb-4 md:mb-0">
                © 2025 ${webSite.title!''} ${webSite.icp!''}
            </div>
            <#include "footer-links.ftl">
        </div>
    </div>
</footer>
<#include "statistcis.ftl">
</body>
</html>
