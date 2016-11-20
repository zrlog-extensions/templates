<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="header.jsp"></jsp:include>
<div class="boxed  push-down-60">
<!-- Meta without image start (Needed for WP theme)-->
<div class="meta">
<div class="row">
<div class="col-xs-12  col-sm-10  col-sm-offset-1  col-md-8  col-md-offset-2">
<div class="meta__container--without-image">
<div class="row">
<div class="col-xs-12  col-sm-8">
<div class="meta__info">
<span class="meta__author"><img width="30" height="30" alt="${log.userName}" src="${_res.avatar}">${log.userName} 发布在 <a href="${rurl}post/sort/${log.typeAlias}">${log.typeName}</a> </span>
<span class="meta__date"><span class="glyphicon glyphicon-calendar"></span>&nbsp;${fn:split(log.releaseTime, ' ')[0]}</span>
</div>
</div>
<div class="col-xs-12  col-sm-4">
<div class="meta__comments">
<span class="glyphicon glyphicon-comment"></span> &nbsp;
<a href="${url}/post/${log.logId}#comment"></a>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<!-- Meta without image end -->
<!-- Start of the blogpost -->
<div class="row">
<div class="col-xs-10  col-xs-offset-1  col-md-8  col-md-offset-2  push-down-60">
<!-- Start of the content -->
<div class="post-content">
<h1>${log.title }</h1>
${log.content}
</div>
<!-- End of the content -->
<div class="row">
<c:if test="${not empty log.keywords}">
<div class="col-xs-12">
<!-- Start of post tags -->
<div class="tags">
<h6>标签</h6>
<hr>
<c:forTokens items="${log.keywords}" delims="," var="tag">
<a class="tags__link" href="${url}/post/tag/${tag}">${tag}</a>
</c:forTokens>
</div>
<!-- End of post tags -->
</div>
</c:if>
<div id="comment">
<!-- Duoshuo Comment BEGIN -->
<div style="padding:20px;margin-bottom: 20px" class="ds-thread" data-thread-key="${log.logId}"
	data-title="${log.title}"
	data-url="${url}post/${log.alias}"></div>
<script type="text/javascript">
	var duoshuoQuery = {short_name:"${webSite.duoshuo_short_name}"};
	(function() {
		var ds = document.createElement('script');
		ds.type = 'text/javascript';ds.async = true;
		ds.src = 'http://static.duoshuo.com/embed.js';
		ds.charset = 'UTF-8';
		(document.getElementsByTagName('head')[0]
		|| document.getElementsByTagName('body')[0]).appendChild(ds);
	})();
</script>
<!-- Duoshuo Comment END -->
</div>
</div>
</div>
</div>
</div>
</div>
<jsp:include page="footer.jsp"></jsp:include>