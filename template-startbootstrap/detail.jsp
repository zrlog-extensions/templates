<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="header.jsp"></jsp:include>
<div class="container">
<div class="row">
    <div class="col-md-9">
        <h1>${log.title}</h1>
        <hr>
        <p><span class="glyphicon glyphicon-time"></span> Posted on ${log.releaseTime}</p>
        <hr>
        <div class="content">${log.content}</div>
        <hr>
<jsp:include page="comment.jsp"></jsp:include>
    </div>
<jsp:include page="widgets.jsp"></jsp:include>
</div>
<jsp:include page="footer.jsp"></jsp:include>
