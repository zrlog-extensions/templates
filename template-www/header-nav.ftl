<#list init.logNavs as lognav>
    <li class="hover:text-primary transition-colors <#if lognav.current> nav-active</#if>">
        <a class="nav-link" href="${lognav.url}">${lognav.navName}</a>
    </li>
</#list>
