<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="col-md-3">
    <div class="well">
        <form action="${baseUrl}post/search">
        <div class="input-group">
            <input type="text" name="key" value="${key}" class="form-control">
            <span class="input-group-btn">
                <button class="btn btn-default" type="submit">
                    <span class="glyphicon glyphicon-search"></span>
            </button>
            </span>
        </div>
        </form>
    </div>
    <div class="well">
        <h4>${_res.category}</h4>
        <div class="row">
            <div class="col-md-12">
                <ul class="list-unstyled">
                   <c:forEach var="type" items="${init.types}">
                        <li><a href="${type.url}">${type.typeName} (${type.typeamount})</a></li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <div class="well">
            <h4>${_res.tag}</h4>
            <div class="row">
                <div  id="tegcloud" class="col-md-12">
                <c:forEach var="tag" items="${init.tags}">
                    <a href="${tag.url}">${tag.text}</a>
                </c:forEach>
                </div>
            </div>
        </div>
</div>