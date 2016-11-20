<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="header.jsp"></jsp:include>
<div class="row-fluid">
	<div class="span12 blog-page">
		<div class="row-fluid">
			<div class="span9 article-block">
				<h3>${log.title }</h3>
				<div class="blog-tag-data">
					<div class="row-fluid">
						<div class="span6">
							<ul class="unstyled inline blog-tags">
								<li>
									<c:forTokens items="${log.keywords}" delims="," var="tag">
									<i class="fa fa-tags"></i>
									<a href="${rurl}post/tag/${tag}" rel="tag">${tag}</a></c:forTokens>
								</li>
							</ul>
						</div>
						<div class="span6 blog-tag-data-inner">
							<ul class="unstyled inline">
							<li><i class="fa fa-calendar"></i> <a href="#">${log.releaseTime.year+1900}年${log.releaseTime.month+1}月${log.releaseTime.date}日</a></li>
							<li><i class="fa fa-comments"></i> <a href="${rurl}post/${log.alias}#comments">${log.commentSize} Comments</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div>
					<P>${log.content}</P>
				</div>
				<hr>
				<c:choose>
				<c:when test="${log.canComment}">
					<c:choose>
						<c:when test="${init.webSite.user_comment_pluginStatus}">
							 <jsp:include page="../../core/duoshuo_comment.jsp"></jsp:include>
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
					</c:when>
				</c:choose>
			</div>
			<div class="span3 blog-sidebar">
				 <jsp:include page="plugs.jsp"></jsp:include>
			</div>
		</div>
	</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>