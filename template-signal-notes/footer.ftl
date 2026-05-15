</main>
<footer class="site-footer">
    <div class="shell site-footer__inner">
        <div class="site-footer__meta">
            <div class="site-footer__title">${webs.title!''}</div>
            <div class="site-footer__desc">${webs.description!''}</div>
        </div>
        <div class="site-footer__links">
            <#list init.logNavs as nav>
                <a href="${nav.url}">${nav.navName}</a>
            </#list>
            ${_res.footerLink!''}
        </div>
    </div>
    <div class="shell site-footer__bottom">
        <span>${_res['copyrightCurrentYear']!''}</span>
        <span>${host!''}</span>
        <#if webs.icp?has_content><span>${webs.icp}</span></#if>
    </div>
</footer>
<#if webs.webCm?has_content><div style="display:none">${webs.webCm!''}</div></#if>
<script src="${url}/js/theme-toggle.js"></script>
</body>
</html>
