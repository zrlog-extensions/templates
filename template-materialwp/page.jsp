<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="include/header.jsp"></jsp:include>
<c:set var="pageLevel" value="2" scope="request"/>
<div id="content" class="site-content">
<div class="container">
	<div class="row">
	<div id="primary" class="col-md-8 col-lg-8">
    <main id="main" class="site-main" role="main">
    <c:forEach var="log" items="${requestScope.data.rows}">
<article class="post type-post status-publish format-standard has-post-thumbnail hentry category-content category-unpublished">
	<div class="card">
	    <c:if test="${not empty log.thumbnail}">
		<div class="entry-img">
            <a href="${log.url}">
            <img width="1600" height="1200" src="${log.thumbnail}" class="attachment-post-thumbnail wp-post-image"/>
            </a>
        </div>
        </c:if>
		<div class="entry-container">
			<header class="entry-header">
				<h1 class="entry-title"><a href="${log.url}" rel="bookmark">${log.title}</a></h1>
                    <div class="entry-meta">
					<span class="posted-on">
					<i class="mdi-action-schedule"></i> <time class="entry-date published">&nbsp;${log.releaseTime.year+1900}-${log.releaseTime.month+1}-${log.releaseTime.date}</time>
					</a></span>
                    <span class="posted-on"><i class="mdi-file-folder-open"></i>
                    <a href="${log.typeUrl}">${log.typeName}</a>
                    </span>
                    <span class="comments-link"><i class="mdi-action-question-answer"></i>
                    <a href="${log.url}#comment">${_res.comment}</a>
                    </span>
                    </div>
            </header>
			<div class="entry-content">
			${log.digest}
            </div>
			<footer class="entry-footer"></footer>
		</div>
	</div>
</article>
</c:forEach>
<nav class="navigation paging-navigation" role="navigation">
<c:if test="${not empty requestScope.pager}">
<ul class="pagination">
<c:if test="${!requestScope.pager.startPage}">
<li class="page-item"><a title="${_res.pageStart}" class="page-link" href="${pager.pageStartUrl}">${_res.pageStart}</a></li>
</c:if>
<c:forEach items="${requestScope.pager.pageList}" var="page">
<li class="page-item<c:if test="${page.current}"> active</c:if>"><a class="page-link" href="${page.url}">${page.desc}</a></li>
</c:forEach>
<c:if test="${!requestScope.pager.endPage}">
<li class="page-item"><a title="${_res.pageEnd}" class="page-link" href="${pager.pageEndUrl}">${_res.pageEnd}</a></li>
</c:if>
</ul>
</c:if>
</nav>

		
		</main>
	</div>
<jsp:include page="include/aside.jsp"></jsp:include>
</div>
</div>
<jsp:include page="include/footer.jsp"></jsp:include>

