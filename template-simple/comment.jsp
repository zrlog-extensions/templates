<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="comments">
    <c:choose>
        <c:when test="${log.canComment}">
            <c:choose>
                <c:when test="${init.webSite.changyan_status eq 'on'}">
                    <!--PC和WAP自适应版-->
                    <div id="SOHUCS" sid="${log.logId}"></div>
                    <style>
                        #SOHUCS #SOHU_MAIN .module-cmt-list .block-title-gw ul li {
                            background-color: #fff;
                        }
                    </style>
                    <script type="text/javascript">
                        (function () {
                            var appid = '${init.webSite.changyan_appId}';
                            var conf = 'prod_e3ec9450cef3977322648b62a820e338';
                            var width = window.innerWidth || document.documentElement.clientWidth;
                            if (width < 960) {
                                window.document.write('<script id="changyan_mobile_js" charset="utf-8" type="text/javascript" src="//changyan.sohu.com/upload/mobile/wap-js/changyan_mobile.js?client_id=' + appid + '&conf=' + conf + '"><\/script>');
                            } else {
                                var loadJs = function (d, a) {
                                    var c = document.getElementsByTagName("head")[0] || document.head || document.documentElement;
                                    var b = document.createElement("script");
                                    b.setAttribute("type", "text/javascript");
                                    b.setAttribute("charset", "UTF-8");
                                    b.setAttribute("src", d);
                                    if (typeof a === "function") {
                                        if (window.attachEvent) {
                                            b.onreadystatechange = function () {
                                                var e = b.readyState;
                                                if (e === "loaded" || e === "complete") {
                                                    b.onreadystatechange = null;
                                                    a()
                                                }
                                            }
                                        } else {
                                            b.onload = a
                                        }
                                    }
                                    c.appendChild(b)
                                };
                                loadJs("//changyan.sohu.com/upload/changyan.js", function () {
                                    window.changyan.api.config({appid: appid, conf: conf})
                                });
                            }
                        })(); </script>
                </c:when>
                <c:otherwise>
                    <h3>
                        《<span>${log.title }</span>》上有 ${log.commentSize} 条评论
                    </h3>
                    <br/>
                    <c:forEach var="comm" items="${requestScope.log.comments}">
                        <ol class="commentlist">
                            <li class="comment even thread-even depth-1"
                                id="li-comment-${comm.cnt }">
                                <article id="comment-${comm.cnt }" class="comment">
                                    <footer class="comment-meta">
                                        <div class="comment-author vcard">
                                            <img src='${templateUrl}/images/default-avatar.jpg' class='avatar avatar-68 photo' height='68' width='68' /><span class="fn"><a href='${comm.userHome }'
                                                              rel='external nofollow' class='url'>${comm.userName}</a>
                                            </span> 在 <a href="${rurl}/${log.aliasT}#comment-${comm.cnt }"><time
                                                pubdate datetime="${comm.commTime}">${comm.commTime.year+1900
                                                }年${comm.commTime.month+1}月${comm.commTime.date}日
                                                ${comm.commTime.hours}:${comm.commTime.minutes}</time> </a> <span
                                                class="says">说道：</span>
                                        </div>
                                    </footer>
                                    <div class="comment-content">
                                        <p>${comm.userComment}</p>
                                    </div>
                                </article></li>

                        </ol>
                    </c:forEach>
                    <div id="respond" class="comment-respond">
                        <form action="${rurl}post/addComment" method="post" id="commentform"
                              class="comment-form">
                            <input type="hidden" name="logId" value="${log.logId}" />
                            <p class="comment-notes">
                                必填项已用<span class="required">*</span>标注
                            </p>
                            <p class="comment-form-author">
                                <label for="author">姓名 <span class="required">*</span>
                                </label> <input id="author" name="userName" type="text" value=""
                                                size="30" aria-required='true' />
                            </p>
                            <p class="comment-form-comment">
                                <label for="comment">评论</label>
                                <textarea id="comment" name="userComment" cols="45" rows="8"
                                          aria-required="true"></textarea>

                            </p>
                            <p class="form-submit">
                                <input type="submit" id="sub" value="发表评论" />
                            </p>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
        </c:otherwise>
    </c:choose>
</div>