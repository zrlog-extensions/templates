<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<footer class="footer">
    <div class="container">
        <div class="col-xs-12  col-md-12">
                <div class="tags widget-tags">
                 <h6>标签</h6>
                    <hr>
                    <c:forEach items="${init.tags}" var="tag">
                        <a href="${rurl}post/tag/${tag.text}" class="tags__link">${tag.text}</a>
                    </c:forEach>
                </div>
            </div>
        <div class="col-xs-12 col-md-4">
            <nav class="widget-navigation  push-down-30">
                <!-- Widget categories -->
                <h6>分类</h6>
                <hr>
                <ul class="navigation">
                    <c:forEach var="type" items="${init.types}">
                        <li>
                            <a href="${rurl}post/sort/${type.alias}">
                            ${type.typeName}(${type.typeamount})
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>

        <div class="col-xs-12  col-md-4">
            <nav class="widget-navigation  push-down-30">
                <h6>归档</h6>
                <hr>
                <ul class="navigation">
                    <c:forEach var="archives" items="${init.archives}">
                        <li><a href="${rurl}post/record/${archives.key}" rel="nofollow">${archives.key}(${archives.value})</a></li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
        <div class="col-xs-12  col-md-4">
            <div class="widget-navigation push-down-30">
                <h6>友链</h6>
                <hr>
                <ul class="navigation">
                    <c:forEach items="${init.links}" var="link">
                    <li><a href="${link.url }" title="${link.alt }" target="_blank">${link.linkName}</a></li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</footer>
<footer class="copyrights">
    <div class="container">
        <div class="row">
            <div class="col-xs-12  col-sm-6">
                &copy; 2017 ${webSite.title}
            </div>
            <div class="col-xs-12  col-sm-6">
                <div class="copyrights--right">
                    Theme by <a href="#" target="_blank">ProteusThemes</a> . Power by <a href="#" target="_blank"> ZrLog</a>
                </div>
            </div>
        </div>
    </div>
</footer>
<div style="display:none">${webSite.webCm}</div>
<script src="${templateUrl}/js/main.js"></script>
</body>
</html>