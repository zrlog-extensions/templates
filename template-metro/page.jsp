<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="header.jsp"></jsp:include>				
	<!-- BEGIN PAGE CONTENT-->
	<div class="row-fluid">
		<div class="span20 blog-page">
			<div class="row-fluid">
				<div class="span9 article-block">
						<c:if test="${not empty requestScope.data}">
							<c:forEach var="log" items="${requestScope.data.rows}">
					<div class="row-fluid">
						<div class="span12  blog-article">
							<h3><a href="${rurl}post/${log.alias}">${log.title}</a></h3>
							<p>${log.digest}</p>
							<a class="btn blue" href="${rurl}post/${log.alias}">
							${_res['more']}
							<i class="m-fa fa-swapright m-fa fa-white"></i>
							</a>
						</div>
					</div>
					<hr>
		</c:forEach>
		</c:if>
<c:if test="${not empty requestScope.pager}">
<div class="pagination pagination-centre">
   <ul>
	<c:if test="${!requestScope.pager.startPage}">
		<li title="${_res.pageStart}" class="extend"><a href="${rurl}${requestScope.yurl}1">${_res.pageStart}</a></li>
	</c:if>
	<c:forEach items="${requestScope.pager.pageList}" var="page">
		<li <c:if test="${page.current}">class="active"</c:if>><a href="${page.url}">${page.desc}</a></li>
	</c:forEach>
	<c:if test="${!requestScope.pager.endPage}">
		<li title="${_res.pageEnd}" class="extend"><a  href="${rurl}${requestScope.yurl}${requestScope.data.total}">${_res.pageEnd}</a></li>
	</c:if>
 </ul>
</div>
</c:if>
	</div>
		<div class="span3 blog-sidebar">
			 <jsp:include page="plugs.jsp"></jsp:include>
		</div>
	</div>
</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>
