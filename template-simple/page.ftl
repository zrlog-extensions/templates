<#include "header.ftl"/>
<#if data?has_content>
    <#assign pageLevel = 2>
    <div id="main">
        <div id="primary">
            <div id="content" role="main">
                <#list data.rows as log>
                    <article class="post type-post status-publish format-standard hentry">
                        <header class="entry-header">
                            <h1 class="entry-title">
                                <a title='链向 ${log.title}' href="${log.url}" rel="bookmark">${log.title}</a>
                            </h1>
                            <div class="entry-meta">
                                <span class="sep">发表于 </span>
                                <time class="entry-date" datetime="${log.releaseTime}">
                                    ${log.releaseTime}
                                </time>
                            </div>
                            <div class="comments-link">
                                <a href="${log.url}#comments" title="《${log.title}》上的评论"> ${log.commentSize}</a>
                            </div>
                        </header>
                        <div class="entry-content">${log.digest}</div>
                        <br/>
                        <footer class="entry-meta">
                    <span class="cat-links">
                        <span class="entry-utility-prep entry-utility-prep-cat-links">发表在</span>
                        <a title="查看'${log.typeName}'中的全部文章" href="${log.typeUrl}"
                           rel="category tag">${log.typeName}</a>
                    </span>
                        </footer>
                    </article>
                </#list>
                <#include "pager.ftl">
            </div>
        </div>
    </div>
<#else>
    <#assign pageLevel = 1>
    <div id="main">
        <section id="primary">
            <div id="content" role="main">
                <article class="post no-results not-found">
                    <header class="entry-header">
                        <h1 class="entry-title">未找到</h1>
                    </header>
                    <div class="entry-content">
                        <p>抱歉，没有符合您搜索条件的结果。请换其它关键词再试。</p>
                        <form method="post" id="searchform" action="${rurl}search">
                            <label for="s" class="assistive-text">搜索</label>
                            <input type="text" class="field" name="key" id="s" placeholder="搜索"/>
                            <input type="submit" class="submit" name="submit" id="searchsubmit" value="搜索"/>
                        </form>
                    </div>
                </article>
            </div>
        </section>
    </div>
</#if>
<#include "plugs.ftl">
<#include "footer.ftl">
