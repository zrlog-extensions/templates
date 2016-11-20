<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<jsp:include page="../../core/core_mate.jsp"/>
	<link href="${url}/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<link href="${url}/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
	<link href="${url}/css/style.css" rel="stylesheet" type="text/css"/>
	<link href="${url}/css/style-metro.css" rel="stylesheet" type="text/css"/>
	<link href="${url}/css/theme/blue.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="container">
		<div class="page-container row-fluid">
			<div class="page-content">
			<div class="container-fluid" >
				<!-- BEGIN PAGE HEADER-->
				<div class="row-fluid">
					<div class="span12">
						<a href="${rurl}" rel="home">
						<h3 class="page-title">
							${webs.title} <small> &nbsp; ${webs.second_title}</small>
						</h3>

						</a>
			<ul class="breadcrumb">
				<c:set value="${rurl}/${requestScope.yurl}" var="nurl"></c:set>
				<c:forEach var="lognav" items="${init.logNavs}">
					<c:choose>
						<c:when test="${lognav.url eq nurl}">
				<li id="current"  ><a href="${lognav.url}"><c:out value="${lognav.navName}" />
				</a><span></span>
				</li>
						</c:when>
						<c:otherwise>
				<li><a href="${lognav.url}"><c:out value="${lognav.navName}" />
				</a><span></span>
				</li>&nbsp;&nbsp;
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</ul>
		</div>
	</div>