<aside id="sidebar" class="sidebar" style="margin-top: 296px; display: block;">
    <div class="sidebar-inner">
        <section class="site-overview sidebar-panel  sidebar-panel-active ">
            <div class="site-author motion-element">
                <img class="site-author-image" src="${_res.avatar!}" alt="${_res.internetName!}">
                <p class="site-author-name">${_res.internetName!}</p>
                <p class="site-description motion-element">${_res.slogan!}</p>
            </div>
            <nav class="site-state motion-element">
                <div class="site-state-item site-state-posts">
                    <span class="site-state-item-count">${init.statistics.totalArticleSize!}</span>
                    <span class="site-state-item-name">日志</span>
                </div>
                <div class="site-state-item site-state-categories">
                    <span class="site-state-item-count">${init.statistics.totalTypeSize!}</span>
                    <span class="site-state-item-name">分类</span>
                </div>
                <div class="site-state-item site-state-tags">
                    <a href="${rurl!}post/tags">
                        <span class="site-state-item-count">${init.statistics.totalTagSize!}</span>
                        <span class="site-state-item-name">标签</span>
                    </a>
                </div>
            </nav>
            <div class="motion-element search">
                <!-- Styles should typically be in a CSS file -->
                <style>
                    /* CSS styles remain unchanged */
                </style>
                <form action="${searchUrl!}" class="search-wrapper cf" method="post">
                    <input type="text" placeholder="${_res.searchTip!}" value="${key!}" name="key" title="${_res.searchTip!}" required="">
                    <button type="submit">${_res.search!}</button>
                </form>
            </div>
            <div class="links-of-author motion-element">
                <#if _res.githubLink??>
                <span class="links-of-author-item">
          <a href="${_res.githubLink!}" target="_blank" title="GitHub">
              <i class="fa fa-fw fa-github"></i>
            GitHub
          </a>
        </span>
            </#if>
            <#if _res.twitterLink??>
            <span class="links-of-author-item">
          <a href="${_res.twitterLink!}" target="_blank" title="Twitter">
              <i class="fa fa-fw fa-twitter"></i>
            Twitter
          </a>
        </span>
        </#if>
        <#if _res.doubanLink??>
        <span class="links-of-author-item">
          <a href="${_res.doubanLink!}" target="_blank" title="豆瓣">
              <i class="fa fa-fw fa-globe"></i>
            豆瓣
          </a>
        </span>
    </#if>
    <#if _res.zhihuLink??>
    <span class="links-of-author-item">
          <a href="${_res.zhihuLink!}" target="_blank" title="知乎">
              <i class="fa fa-fw fa-globe"></i>
            知乎
          </a>
        </span>
</#if>
</div>
</section>
</div>
</aside>
