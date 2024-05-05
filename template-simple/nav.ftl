<header id="branding" role="banner">
    <hgroup>
        <h1 id="site-title">
            <span><a href="${rurl}" rel="home">${webs.title}</a></span>
        </h1>
        <h2 id="site-description">${webs.second_title}</h2>
    </hgroup>
    <nav id="access" role="navigation">
        <div>
            <ul class="menu">
                <#list init.logNavs as lognav>
                <#if lognav.url == requrl>
                <li id="current" class="menu-item menu-item-type-taxonomy menu-item-object-category current-menu-item">
                    <a href="${lognav.url}">${lognav.navName}</a><span></span>
                </li>
                <#else>
                <li>
                    <a href="${lognav.url}">${lognav.navName}</a><span></span>
                </li>
            </#if>
        </#list>
        </ul>
        </div>
    </nav>
</header>