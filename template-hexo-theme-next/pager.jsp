<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:if test="${not empty requestScope.pager}">
<nav class="pagination">
	<c:forEach items="${requestScope.pager.pageList}" var="page">
		<a class="page-number <c:if test="${page.current}">current</c:if>" href="${page.url}">${page.desc}</a>
	</c:forEach>
</nav>
</c:if>