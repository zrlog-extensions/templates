<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="header.jsp"/>
<c:choose>
	<c:when test="${empty requestScope.data}">
		<c:set var="pageLevel" value="1" scope="request"/>
		<div id="main">
		<section id="primary">
			<div id="content" role="main">
				<article class="post no-results not-found">
					<header class="entry-header">
						<h1 class="entry-title">未找到</h1>
					</header>
					<div class="entry-content">
						<p>抱歉，没有符合您搜索条件的结果。请换其它关键词再试。</p>
						<form method="post" id="searchform" action="${rurl }post/search">
							<label for="s" class="assistive-text">搜索</label> <input
								type="text" class="field" name="key" id="s" placeholder="搜索" />
							<input type="submit" class="submit" name="submit"
								id="searchsubmit" value="搜索" />
						</form>
					</div>
				</article>
			</div>
		</section>
	</c:when>
	<c:otherwise>
		<c:set var="pageLevel" value="2" scope="request"/>
		<div id="main">
		<div id="primary">
		<div id="content" role="main">
			<c:if test="${not empty requestScope.data}">
				<c:forEach var="log" items="${requestScope.data.rows}">
					<article
						class="post type-post status-publish format-standard hentry">
						<header class="entry-header">
							<h1 class="entry-title">
								<a title='链向 ${log.title}' href="${rurl}post/${log.alias}" rel="bookmark">${log.title}</a>
							</h1>
							<DIV class="entry-meta">
								<SPAN class="sep">发表于 </SPAN><time
										class="entry-date" datetime="${log.releaseTime}">${log.releaseTime.year+1900}年${log.releaseTime.month+1}月${log.releaseTime.date}日</time>
								</SPAN>
							</DIV>
							<div class="comments-link">
								<a href="${rurl}post/${log.alias}#comments"
									title="《${log.title}》上的评论"> ${log.commentSize}</a>
							</div>
						</header>
						<DIV class="entry-content">${log.digest}</DIV>
						<br/>
						<footer class="entry-meta">
							<SPAN class="cat-links">
							<SPAN class="entry-utility-prep entry-utility-prep-cat-links">发表在</SPAN>
								<A title="查看'${log.typeName}'中的全部文章" href="${rurl}post/sort/${log.typeAlias}"
								rel="category tag">${log.typeName}</A>
							</SPAN>
						</footer>
					</article>
				</c:forEach>
			</c:if>
			<jsp:include page="pager.jsp"/>
		</DIV>
	</DIV>
	</c:otherwise>
</c:choose>
<jsp:include page="plugs.jsp"/>
<jsp:include page="footer.jsp"/>
