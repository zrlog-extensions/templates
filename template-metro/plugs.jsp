<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<DIV>
<div class="row-fluid search-forms search-default">
		<form action="${rurl }post/search" class="form-search" method="post">
			<div class="chat-form">
				<div class="input-cont">
					<input type="text" name="key" value="<c:out value="${sessionScope.key}" />" class="m-wrap" placeholder="${_res.searchTip}">
				</div>
				<button class="btn blue" type="submit">搜索 &nbsp; <i class="m-fa fa-swapright m-fa fa-white"></i></button>
			</div>
		</form>
	</div>
	<ASIDE class="widget widget_recent_entries" id="recent-posts-2">
		<c:choose>
			<c:when test="${not empty init.plugins}">
				<c:forEach var="plugin" items="${init.plugins}">
					<c:choose>
						<c:when test="${plugin.isSystem==false and pageLevel>=plugin.level}">
		<div class="widget-title">
			<h3>${plugin.pTitle}</h3>
			<p>${plugin.content}</p>
			<br />
		</div>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${plugin.pluginName eq 'types' }">
		<h3><c:out value="${plugin.pTitle}" /></h3>
		<div class="top-news">
			<c:forEach var="type" items="${init.types}">
				 <a class="btn blue" href="${rurl}post/sort/${type.alias}">${type.typeName} (${type.typeamount})</a>
			</c:forEach>
		</div>
								</c:when>
								<c:when test="${plugin.pluginName eq 'links' and pageLevel>=plugin.level}">
				<h3><c:out value="${plugin.pTitle}" /></h3>
		<div class="top-news">
				<c:forEach items="${init.links}" var="link">
					<a class="btn blue" href="${link.url }" title="${link.alt }" target="_blank">${link.linkName}</a>
				</c:forEach>
		</div>
								</c:when>
								<c:when test="${plugin.pluginName eq 'archives'}">
		<h3>
				<c:out value="${plugin.pTitle}" />
			</h3>
		<div class="top-news">
				<c:forEach var="archives" items="${init.archives}">
					 <a class="btn blue" href="${rurl}post/record/${archives.key}" rel="nofollow">${archives.key}
							(${archives.value})</a>
				</c:forEach>
		</div>
								</c:when>
								<c:when test="${plugin.pluginName eq 'tags'}">
		<h3>
				<c:out value="${plugin.pTitle}" />
		</h3>
		<div class="taglist" id="tags">
			<ul class="unstyled inline sidebar-tags">
			 <c:forEach items="${init.tags}" var="tag">
				<li><i class="fa fa-tags"></i><a href="${rurl}post/tag/${tag.text}" title="${tag.text}上共有(${tag.count})文章">${tag.text}</a></li>
			 </c:forEach>
			 </ul>
		</div>
								</c:when>
							</c:choose>
						</c:otherwise>
						
					</c:choose>
				</c:forEach>
			</c:when>
		</c:choose>
	</aside>
</div>
