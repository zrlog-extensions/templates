<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
  <section id="posts" class="posts-expand">
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
            <time datetime="${log.releaseTime}" content="${log.releaseTime.year+1900}-${log.releaseTime.month+1}-${log.releaseTime.date}">
              ${log.releaseTime.year+1900}-${log.releaseTime.month+1}-${log.releaseTime.date}
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
         <div>
         ${log.content}
         </div>
    </div>
    <footer class="post-footer">
                    <c:if test="${not empty log.keywords}">
                    <!-- Start of post tags -->
                     <div class="post-tags">
                    <c:forTokens items="${log.keywords}" delims="," var="tag">
                    <a ref="tag" href="${rurl}post/tag/${tag}">${tag}</a>
                    </c:forTokens>
                    <!-- End of post tags -->
                    </div>
</c:if>
        <div class="post-nav">
                  <div class="post-nav-next post-nav-item">
                  <a title="${log.nextLog.title}" href="${log.nextLog.url}">${_res.nextArticle}：${log.nextLog.title}&nbsp;<i class="fa fa-chevron-right"></i></a>
                  </div>
                  <div class="post-nav-prev post-nav-item">
                  <a title="${log.lastLog.title}" href="${log.lastLog.url}"><i class="fa fa-chevron-left"></i> &nbsp;  ${_res.lastArticle}：${log.lastLog.title}</a>
                  </div>
                </div>
    </footer>
      <div id="comments" class="comment">
      <jsp:include page="comment.jsp"></jsp:include>
       </div>
  </article>
  </section>
          </div>
        </div>