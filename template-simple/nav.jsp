<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<header id="branding" role="banner">
    <hgroup>
    <h1 id="site-title">
        <span><a href="${rurl}" rel="home">${webs.title}</a></span>
    </h1>
    <h2 id="site-description">${webs.second_title}</h2>
    </hgroup>
    <nav id="access" role="navigation">
    <div>
        <ul class="menu">
            <c:forEach var="lognav" items="${init.logNavs}">
                <c:choose>
                    <c:when test="${lognav.url eq requrl}">
            <li id="current" class="menu-item menu-item-type-taxonomy menu-item-object-category current-menu-item"><a href="${lognav.url}"><c:out value="${lognav.navName}" />
            </a><span></span>
            </li>
                    </c:when>
                    <c:otherwise>
            <li><a href="${lognav.url}"><c:out value="${lognav.navName}" />
            </a><span></span>
            </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </ul>
    </div>
    </nav>
</header>