<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="include/header.jsp"></jsp:include>
<div id="content" class="site-content">
<div class="container">
	<div class="row">
	<div id="primary" class="col-md-8 col-lg-8">
    <main id="main" class="site-main" role="main">
<article class="post type-post status-publish format-standard has-post-thumbnail hentry category-content category-unpublished">
	<div class="card">
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
			${log.content}
            </div>
			<footer class="entry-footer"></footer>
			<hr/>
		</div>
	</div>
</article>
<jsp:include page="include/comment.jsp"></jsp:include>
		</main>
	</div>
<jsp:include page="include/aside.jsp"></jsp:include>
</div> <!-- .row -->
</div> <!-- .container -->
<jsp:include page="include/footer.jsp"></jsp:include>