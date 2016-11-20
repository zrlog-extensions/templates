<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>

    <jsp:include page="../../core/core_mate.jsp"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${url}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${url}/css/blog-home.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" media="screen" href="${templateUrl}/css/editormd.css" />

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <c:if test="${not empty _res.navBarBrand}">
              <a class="navbar-brand brand-self" href="${rurl}"><b>${_res.navBarBrand}</b></a>
              </c:if>
          </div>
              <div class="collapse navbar-collapse" id="navbar">
                  <ul class="nav navbar-nav">
              <c:forEach var="lognav" items="${init.logNavs}">
                    <c:choose>
                        <c:when test="${lognav.current}">
                <li class="active"><a href="${lognav.url}"><c:out value="${lognav.navName}" /></a></li>
                        </c:when>
                        <c:otherwise>
                <li><a href="${lognav.url}"><c:out value="${lognav.navName}" /></a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </ul>
          </div>
        </div>
    </nav>