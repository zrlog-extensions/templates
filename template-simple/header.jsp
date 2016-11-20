<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<c:set var="webs" value="${init.webSite}" scope="request"></c:set>
<meta charset="utf-8"/>
<link rel="shortcut icon" type="image/x-icon" href="${rurl}/favicon.ico" />
<meta name="description" content="${webs.description}"/>
<c:choose>
<c:when test="${empty requestScope.log or empty requestScope.log.keywords}">
<meta name="keywords" content="${webs.keywords}"/>
</c:when>
<c:otherwise>
<meta name="keywords" content="${requestScope.log.keywords}"/>
</c:otherwise>
</c:choose>
<title><c:if test="${not empty requestScope.log.title}">${requestScope.log.title} - </c:if>${webs.title} - ${webs.second_title}</title>
<link rel="stylesheet" type="text/css" href="${url}/css/editormd.css" />
<link type="text/css" href="${url}/style.css" rel="stylesheet"/>
<script type="text/javascript" src="${url}/js/html5.js"></script>
<script type="text/javascript" src="${url}/js/jquery-1.4.2.min.js"></script>
</head>
<body>
	<div class="hfeed" id="page">
<jsp:include page="nav.jsp"/>
