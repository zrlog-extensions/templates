<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="header.jsp"></jsp:include>
<div class="container">
<div class="row">
    <div class="col-md-9">
        <c:forEach var="log" items="${requestScope.data.rows}">
        <h2>
            <a href="${log.url}">${log.title}</a>
        </h2>
        <p><span class="glyphicon glyphicon-time"></span> Posted on ${log.releaseTime}</p>
        <hr>
        <c:if test="${not empty log.thumbnail}">
        <img width="697px" class="img-responsive" src="${log.thumbnail}" alt="">
        <br>
        </c:if>
        <p>${log.digest}</p>
        <br/>
        <a class="btn btn-primary" href="${log.url}">${_res['readMore']} <span class="glyphicon glyphicon-chevron-right"></span></a>
        <hr>
        </c:forEach>
        <c:if test="${not empty requestScope.pager}">
        <div class="text-center">
        <nav aria-label="Page navigation">
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
        </nav>
        </div>
        </c:if>
    </div>
<jsp:include page="widgets.jsp"></jsp:include>
</div>
<jsp:include page="footer.jsp"></jsp:include>
