<#if log.canComment>
    <#if (init.webSite.changyan_status == "on")>
        <div class="comments-wrapper">
            <plugin name="changyan" view="widget" param="articleId=${log.logId}"/>
        </div>
    <#else>
        <#if log.comments?has_content>
            <h2>${_res.comments}</h2>
        </#if>
        <#list log.comments as comment>
            <ul class="comments">
                <li>
                    <div class="comment">
                        <p>${comment.userComment}</p>
                        <p class="small"><a
                                    rel="nofollow">${comment.userName}</a> ${_res.on} ${comment.commTime}
                        </p>
                    </div>
                </li>
            </ul>
        </#list>
        <div class="comments-wrapper">
            <div class="reply">
                <h2 id="comment">${_res.comment}</h2>
                <p class="comment-write">
                    <label class="hidden" for="userComment">Message</label>
                    <textarea class="txpCommentInputMessage" id="userComment" rows="15" cols="45" name="userComment"
                              required></textarea>
                </p>
                <form action="${rurl}addComment" method="post">
                    <div class="input-group">
                        <p>
                            <label for="name">${_res.name}</label>
                            <input type="text" id="name" class="comment_name_input" size="25" name="userName"
                                   required>
                        </p>
                        <p>
                            <label for="email">${_res.email}</label>
                            <input type="text" id="email" class="comment_email_input" size="80" name="userMail">
                        </p>
                        <p>
                            <label for="web">${_res.website}</label>
                            <input type="text" id="web" class="comment_web_input" size="255" name="webHome">
                        </p>
                    </div>
                    <div class="button-set">
                            <span class="submit"><input type="submit" id="txpCommentSubmit" class="button" name="submit"
                                                        value="${_res.submit}"></span>
                    </div>
                    <input type="hidden" name="logId" value="${log.logId}">
                </form>
            </div>
        </div>
    </#if>
</#if>