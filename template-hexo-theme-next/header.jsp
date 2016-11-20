<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  Map<String,Object> res = (Map<String,Object>)request.getAttribute("_res");
  if(res.get("avatar")==null || "".equals(res.get("avatar"))){
    res.put("avatar",request.getAttribute("url")+"/images/avatar.gif");
  }
  if(res.get("title")==null){
    String host = request.getHeader("host");
    if(host.indexOf(":")!=-1){
        host = host.substring(0,host.indexOf(":"));
    }
    res.put("title",host);
  }
%>
<!doctype html>
<html>
<head>
<jsp:include page="../../core/core_mate.jsp"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
<link rel="stylesheet" type="text/css" media="screen" href="${templateUrl}/css/editormd.css" />
<link href="${templateUrl}/css/main.css?v=5.1.0" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="container one-collumn sidebar-position-left page-home">
    <div class="headband"></div>
    <header id="header" class="header">
      <div class="header-inner"><div class="site-meta">
      <div class="custom-logo-site-title" id="navbar">
        <a href="/" class="brand" rel="start" style="opacity: 1;">
          <span class="logo-line-before"><i></i></span>
          <span class="site-title" style="opacity: 1; top: 0px;">${webs.title}</span>
          <span class="logo-line-after"><i></i></span>
        </a>
      </div>
    <p class="site-subtitle" style="opacity: 1; top: 0px;">${webs.second_title}</p>
</div>
<div class="site-nav-toggle">
<button>
<span class="btn-bar"></span>
<span class="btn-bar"></span>
<span class="btn-bar"></span>
</button>
</div>
<nav class="site-nav">
<ul id="menu" class="menu">
<c:forEach var="lognav" items="${init.logNavs}">
<c:choose>
<c:when test="${lognav.current}">
<li class="menu-item activem enu-item-home menu-item-active" style="opacity: 1; transform: translateY(0px);" ><a href="${lognav.url}"><c:out value="${lognav.navName}" /></a></li>
</c:when>
<c:otherwise>
<li class="menu-item menu-item-home " style="opacity: 1; transform: translateY(0px);"><a href="${lognav.url}"><c:out value="${lognav.navName}" /></a></li>
</c:otherwise>
</c:choose>
</c:forEach>
</ul>
</nav>
 </div>
    <jsp:include page="aside.jsp"/>
    </header>
        <main id="main" class="main">
          <div class="main-inner">
