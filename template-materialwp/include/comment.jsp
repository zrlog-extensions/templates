<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:choose>
<c:when test="${log.canComment}">
<div id="comments" class="comments-area card">
<c:choose>
<c:when test="${init.webSite.changyan_status eq 'on'}">
<!--PC和WAP自适应版-->
<div id="SOHUCS" sid="${log.logId}" ></div>
<style>
#SOHUCS #SOHU_MAIN .module-cmt-list .block-title-gw ul li {
background-color: #fff;
}
</style>
<script type="text/javascript">
(function(){
var appid = '${init.webSite.changyan_appId}';
var conf = 'prod_e3ec9450cef3977322648b62a820e338';
var width = window.innerWidth || document.documentElement.clientWidth;
if (width < 960) {
window.document.write('<script id="changyan_mobile_js" charset="utf-8" type="text/javascript" src="//changyan.sohu.com/upload/mobile/wap-js/changyan_mobile.js?client_id=' + appid + '&conf=' + conf + '"><\/script>'); } else { var loadJs=function(d,a){var c=document.getElementsByTagName("head")[0]||document.head||document.documentElement;var b=document.createElement("script");b.setAttribute("type","text/javascript");b.setAttribute("charset","UTF-8");b.setAttribute("src",d);if(typeof a==="function"){if(window.attachEvent){b.onreadystatechange=function(){var e=b.readyState;if(e==="loaded"||e==="complete"){b.onreadystatechange=null;a()}}}else{b.onload=a}}c.appendChild(b)};loadJs("//changyan.sohu.com/upload/changyan.js",function(){window.changyan.api.config({appid:appid,conf:conf})}); } })(); </script>
</c:when>
<c:otherwise>
<c:if test="${not empty log.comments}">
<h2>${_res.comments}</h2></c:if>
<c:forEach items="${log.comments}" var="comment">
<ul class="comments">
<li><p>${comment.userComment}</p>
<p class="small"><a rel="nofollow" >${comment.userName }</a> ${_res.on}&nbsp;${comment.commTime}</p>
</li></ul>
</c:forEach>
<div id="cwrapper">
<div id="respond" class="comment-respond">
<h3 id="reply-title" class="comment-reply-title">Leave a Comment <small><a rel="nofollow" id="cancel-comment-reply-link" href="/scheduled/#respond" style="display:none;">Cancel reply</a></small></h3>
<form action="" method="post" id="commentform" class="comment-form" novalidate>
<p class="comment-notes"><span id="email-notes">Your email address will not be published.</span> Required fields are marked <span class="required">*</span></p>							<div class="form-group"><input class="form-control floating-label" placeholder="Name" id="author" name="author" type="text" value="" size="30" aria-required='true' /></div>
<div class="form-group"><input class="form-control floating-label" placeholder="Email" id="email" name="email" type="text" value="" size="30" aria-required='true' /></div>
<div class="form-group"><input class="form-control floating-label" placeholder="Website" id="url" name="url" type="text" value="" size="30" /></div>
<div class="form-group"><textarea class="form-control floating-label" placeholder="Comments" rows="10" id="comment" name="comment" aria-required="true"></textarea></div>
<p class="form-submit"><input name="submit" type="submit" id="submit" class="submit" value="Submit" /> <input type='hidden' name='comment_post_ID' value='418' id='comment_post_ID' /></p>
<input type="hidden" name="logId" value="${log.logId }">
</form>
</div>
</div>
</c:otherwise>
</c:choose>
</div>
</c:when>
</c:choose>
