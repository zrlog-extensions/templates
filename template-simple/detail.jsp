<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp"></jsp:include>
<c:set var="pageLevel" value="1" scope="request"/>
<div id="main">
    <c:choose>
    <c:when test="${empty log}">
        <jsp:include page="404.jsp"></jsp:include>
    </c:when>
    <c:otherwise>
    <DIV id="primary">
        <DIV id="content" role="main">
            <NAV id="nav-single">
                <H3 class="assistive-text">文章导航</H3>
                <span class="nav-previous"><a
                        href="${rurl }post/${log.lastLog.alias}"
                        title="${log.lastLog.title}" rel="prev"><span
                        class="meta-nav">&larr;</span> 上一篇</a> </span> <span class="nav-next"><a
                    href="${rurl }post/${log.nextLog.alias}"
                    title="${log.nextLog.title}" rel="next">下一篇 <span
                    class="meta-nav">&rarr;</span> </a> </span>
            </NAV>
            <ARTICLE
                    class="post type-post status-publish format-standard hentry">
                <HEADER class="entry-header">
                    <H1 class="entry-title">${log.title }</H1>
                    <DIV class="entry-meta">
                        <SPAN class="sep">发表于 </SPAN><A href="${rurl}post/${log.alias}"
                                                        rel="bookmark">
                        <time class="entry-date" pubdate=""
                              datetime="${log.releaseTime}">${log.releaseTime.year+1900}年${log.releaseTime.month+1}月${log.releaseTime.date}日
                        </time>
                    </A>
                    </DIV>
                </HEADER>
                <DIV class="entry-content">
                    <P>${log.content}</P>
                </DIV>
                <br/>
                <footer class="entry-meta">
                    此条目是由 ${log.userName} 发表在 <A title="查看${log.typeName}中的全部文章"
                                                 href="${rurl}post/sort/${log.typeAlias}"
                                                 rel="category tag">${log.typeName}</A>
                    分类目录的
                    <c:if test="${not empty log.keywords}">，并贴了 <c:forTokens
                            items="${log.keywords}" delims="," var="tag">
                        <a href="${rurl}post/tag/${tag}" rel="tag">${tag}</a>&nbsp;</c:forTokens>
                        标签 </c:if>
                </footer>
                <DIV id="copyinfo">
                    <P>
                        转载请注明作者和出处（${webs.title}），并添加本页链接<BR>原文链接:
                        <A title="${log.title }" href="${rurl}post/${log.alias}"><SPAN
                                style="color: rgb(51, 102, 255);" span="">${rurl}post/${log.alias}</SPAN>
                        </A>
                    </P>
                </DIV>
            </ARTICLE>
            <jsp:include page="comment.jsp"></jsp:include>
        </div>
        </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="plugs.jsp"></jsp:include>
</div>
<jsp:include page="footer.jsp"></jsp:include>