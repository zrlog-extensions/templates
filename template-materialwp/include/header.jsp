<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="../../../core/core_mate.jsp"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel='stylesheet' id='bootstrap-styles-css'  href='${templateUrl}/css/bootstrap.min.css?ver=3.3.1' type='text/css' media='all' />
<link rel='stylesheet' id='ripples-styles-css'  href='${templateUrl}/css/ripples.min.css?ver=4.3.11' type='text/css' media='all' />
<link rel='stylesheet' id='material-styles-css'  href='${templateUrl}/css/material-wfont.min.css?ver=4.3.11' type='text/css' media='all' />
<link rel="stylesheet" type="text/css" media="screen" href="${templateUrl}/css/editormd.css" />
<link rel='stylesheet' id='materialwp-style-css'  href='${templateUrl}/style.css?ver=4.3.11' type='text/css' media='all' />
<script type='text/javascript' src='${templateUrl}/js/jquery/jquery.js?ver=1.11.3'></script>
<script type='text/javascript' src='${templateUrl}/js/jquery/jquery-migrate.min.js?ver=1.2.1'></script>
<style>
.navbar-collapse {
padding-right: 0px;
padding-left: 0px;
}
</style>
</head>

<body>
<div id="page" class="hfeed site">
	<header id="masthead" class="site-header" role="banner">
		<nav class="navbar navbar-inverse" role="navigation">
		  <div class="container">
		    <div class="navbar-header">
		      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </button>
		    <c:if test="${not empty _res.navBarBrand}">
			<a class="navbar-brand" rel="home" href="${baseUrl}">${_res.navBarBrand}</a>
			</c:if>
    		</div>
    			<div class="navbar-collapse collapse" id="bs-example-navbar-collapse-1">
<ul id="menu-empty-menu" class="nav navbar-nav navbar-left">
<c:forEach var="lognav" items="${init.logNavs}">
<li class="menu-item menu-item-type-post_type menu-item-object-page <c:if test='${lognav.current}'>active</c:if>">
<a  href="${lognav.url}">${lognav.navName}</a>
</li>
</c:forEach>
</ul>
	        		<form class="navbar-form navbar-right" role="search" method="get" id="searchform" action="${searchUrl}">
	        			<div class="form-control-wrapper">
                        	<input name="key" id="s" type="text" class="form-control col-lg-8" placeholder="${_res.searchTip}">
                        </div>
                    </form>
        		</div>
        	</div>
		</nav>
	</header>
