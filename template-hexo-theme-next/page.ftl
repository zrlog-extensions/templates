<#include "header.ftl">
<div class="content-wrap">
  <div id="content" class="content">
    <section id="posts" class="posts-expand">
      <#if data?has_content>
      <#list data.rows as log>
      <article class="post post-type-normal" style="opacity: 1; display: block; transform: translateY(0px);">
        <header class="post-header">
          <h1 class="post-title">
            <a class="post-title-link" href="${log.url}">
              ${log.title}
            </a>
          </h1>
          <div class="post-meta">
                <span class="post-time">
                  <span class="post-meta-item-icon">
                    <i class="fa fa-calendar-o"></i>
                  </span>
                  <span class="post-meta-item-text">发表于</span>
                  <time datetime="${log.releaseTime}">
                    ${log.releaseTime}
                  </time>
                </span>
            <span class="post-category">
                  &nbsp; | &nbsp;
                  <span class="post-meta-item-icon">
                    <i class="fa fa-folder-o"></i>
                  </span>
                  <span class="post-meta-item-text">分类于</span>
                  <span>
                    <a href="${log.typeUrl}" rel="index">
                      <span>${log.typeName}</span>
                    </a>
                  </span>
                </span>
            <span class="post-comments-count">
                  &nbsp; | &nbsp;
                  <a href="${log.url}#comments">
                    <span class="post-comments-count">${log.commentSize}条评论</span>
                  </a>
                </span>
            <span id="${log.url}" class="leancloud_visitors" data-flag-title="${log.title}">
                  &nbsp; | &nbsp;
                  <span class="post-meta-item-icon">
                    <i class="fa fa-eye"></i>
                  </span>
                  <span class="post-meta-item-text">阅读次数 </span>
                  <span class="leancloud-visitors-count">${log.click}</span>
                </span>
          </div>
        </header>
        <div class="post-body">
          ${log.digest!''}
          <div class="post-more-link text-center">
            <a class="btn" href="${log.url}" rel="contents">
              阅读全文 »
            </a>
          </div>
        </div>
        <footer class="post-footer">
          <div class="post-eof"></div>
        </footer>
      </article>
    </#list>
  </#if>
  </section>
  <#include "pager.ftl">
</div>
</div>
<div class="sidebar-toggle">
  <div class="sidebar-toggle-line-wrap">
    <span class="sidebar-toggle-line sidebar-toggle-line-first"></span>
    <span class="sidebar-toggle-line sidebar-toggle-line-middle"></span>
    <span class="sidebar-toggle-line sidebar-toggle-line-last"></span>
  </div>
</div>
<#include "footer.ftl">
