<div id="comments" style="padding-bottom: 180px">
    <#if log.canComment??>
    <#if init.webSite.changyan_status == "on">
        <plugin name="changyan" view="widget" param="articleId=${log.logId!''}"></plugin>
    <#else>
    <h3>
        《<span>${log.title!}</span>》上有 ${log.commentSize!} 条评论
    </h3>
    <br/>
    <#list log.comments as comm>
    <ol class="commentlist">
        <li class="comment even thread-even depth-1" id="li-comment-${comm.cnt}">
            <article id="comment-${comm.cnt}" class="comment">
                <footer class="comment-meta">
                    <div class="comment-author vcard">
                        <img src='${templateUrl}/images/default-avatar.jpg' class='avatar avatar-68 photo' height='68' width='68' />
                        <span class="fn"><a href='${comm.userHome}' rel='external nofollow' class='url'>${comm.userName}</a></span>
                        在 <a href="${rurl}/${log.aliasT}#comment-${comm.cnt}">
                        <time pubdate datetime="${comm.commTime}">
                            ${comm.commTime?string("yyyy年MM月dd日 HH:mm")}
                        </time>
                    </a> <span class="says">说道：</span>
                    </div>
                </footer>
                <div class="comment-content">
                    <p>${comm.userComment}</p>
                </div>
            </article>
        </li>
    </ol>
</#list>
<div id="respond" class="comment-respond">
    <form action="${rurl}addComment" method="post" id="commentform" class="comment-form">
        <input type="hidden" name="logId" value="${log.logId}" />
        <p class="comment-notes">
            必填项已用<span class="required">*</span>标注
        </p>
        <p class="comment-form-author">
            <label for="author">姓名 <span class="required">*</span></label>
            <input id="author" name="userName" type="text" value="" size="30" aria-required='true' />
        </p>
        <p class="comment-form-comment">
            <label for="comment">评论</label>
            <textarea id="comment" name="userComment" cols="45" rows="8" aria-required="true"></textarea>
        </p>
        <p class="form-submit">
            <input type="submit" id="sub" value="发表评论" />
        </p>
    </form>
</div>
</#if>
</#if>
</div>
