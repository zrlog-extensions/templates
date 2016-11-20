<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="header.jsp"></jsp:include>
  <!-- Begin pageData -->
  <!-- Begin tip -->
<c:forEach var="log" items="${requestScope.data.rows}">
<div class="boxed  push-down-40">
  <!-- Meta without image start (Needed for WP theme)-->
  <div class="meta">
        <div class="row">
          <div class="col-xs-10  col-xs-offset-1  col-md-8  col-md-offset-2 push-down-10">
          <div class="meta__container--without-image">
            <div class="meta__info">
              <span class="meta__author"><img width="30" height="30" alt="${log.userName}" src="${_res.avatar}"> ${log.userName} 发布在 <a href="${rurl}post/sort/${log.typeAlias}">${log.typeName}</a> </span>
              <span class="meta__date"><span class="glyphicon glyphicon-calendar"></span>&nbsp;${fn:split(log.releaseTime, ' ')[0]}</span>
            </div>
          </div>
        </div>
    </div>
  </div>
  <!-- Meta without image end -->
  <!-- Start of the blogpost -->
  <div class="row">
    <div class="col-xs-10  col-xs-offset-1  col-md-8  col-md-offset-2  push-down-10">
      <!-- Start of the content -->
      <div class="post-content--front-page">
        <h2 class="front-page-title">
          <a href="${rurl}post/${log.logId}">${log.title}</a>
        </h2>
        <div class="post-content" style="padding-bottom: 20px"> ${log.digest}</div>
        <!-- End of the content -->
        <a href="${rurl}post/${log.logId}">
          <div class="read-more">
            阅读更多
            <div class="read-more__arrow">
              <span class="glyphicon  glyphicon-chevron-right"></span>
            </div>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>
</c:forEach>
<!-- End pageData -->
<jsp:include page="pagenav.jsp"></jsp:include>
<jsp:include page="plugin.jsp"></jsp:include>
</div>
<jsp:include page="footer.jsp"></jsp:include>
