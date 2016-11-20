<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
Map<String,Object> res = (Map<String,Object>)request.getAttribute("_res");
if(res.get("avatar")==null || "".equals(res.get("avatar"))){
    res.put("avatar",request.getAttribute("url")+"/images/avatar.gif");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<c:set var="webSite" value="${init.webSite}" scope="request"></c:set>
<c:set var="webs" value="${init.webSite}" scope="request"></c:set>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" type="image/x-icon" href="${url}favicon.ico" />
<meta name="description" content="${webSite.description}"/>
<meta name="keywords" content="${webSite.keywords}"/>
<title>${webSite.title} - ${webSite.second_title}</title>
<!-- Custom styles for this template -->
<link rel="stylesheet" href="${templateUrl }/stylesheets/editormd.css"/>
<link rel="stylesheet" href="${templateUrl }/stylesheets/pager.css"/>
<link rel="stylesheet" href="${templateUrl }/stylesheets/main.css"/>
<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
<body>
<!-- header -->
<header class="header  push-down-45">
<div class="container">
<!-- Brand and toggle get grouped for better mobile display -->
<div class="navbar-header">
<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#readable-navbar-collapse">
<span class="sr-only">Toggle navigation</span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</button>
</div>
<nav class="navbar  navbar-default" role="navigation">
<!-- Collect the nav links, forms, and other content for toggling -->
<div class="collapse  navbar-collapse" id="readable-navbar-collapse">
<ul class="navigation">
<c:forEach var="lognav" items="${init.logNavs}">
<li <c:if test="${lognav.current}"> class="active" </c:if>><a href="${lognav.url}">${lognav.navName}</a></li>
</c:forEach>
</ul>
</div><!-- /.navbar-collapse -->
</nav>
<div class="hidden-xs  hidden-sm">
<a href="#" class="search__container  js--toggle-search-mode"> <span class="glyphicon  glyphicon-search"></span> </a>
</div>
</div>
</header>
<!-- Search - Open panel -->
<div class="search-panel">
<div class="container">
<div class="row">
<div class="col-xs-12">
<form action="${rurl}post/search" method="post">
<input type="text" class="search-panel__form  js--search-panel-text" name="key" placeholder="请输入关键字">
<p class="search-panel__text">回车开始搜索，按Esc取消</p>
</form>
</div>
</div>
</div>
</div>
<c:if test="${not empty tipsType}">
<div class="container">
<div class="boxed push-down-10">
<div class="row">
<div class="col-xs-12 col-xs-offset-1 col-md-8 col-md-offset-2  push-down-10">
  <h4>${tipsType}目录：${tipsName}</h4>
  <p>以下是与 ${tipsType} "${tipsName}" 相关联的文章</p>
</div>
</div>
</div>
</div>
</c:if>
<div class="container">