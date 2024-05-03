<#include "header.ftl">
<div class="content-wrap">
    <div id="content" class="content">
        <section id="posts" class="posts-expand">
            <div class="tag-cloud">
                <div class="tag-cloud-title">
                    目前共计 ${init.statistics.totalTagSize!} 个标签
                </div>
                <script src="${templateUrl}/lib/jquery/jquery-1.10.2.min.js"></script>
                <script type="text/javascript">
                    $(document).ready(function(){
                        var tags_a = $("#tags").find("a");
                        tags_a.each(function(){
                            var x = 6;
                            var y = 0;
                            var rand = parseInt(Math.random() * (x - y + 1) + y);
                            $(this).addClass("size"+rand);
                        });
                    });
                </script>
                <style type="text/css">
                    .taglist a {padding:0px;display:inline-block;white-space:nowrap;}
                    a.size1 {font-size:10px;padding:2px;color:#804D40;}
                    a.size1:hover {color:#E13728;}
                    a.size2 {padding:2px;font-size:12px;color:#B9251A;}
                    a.size2:hover {color:#E13728;}
                    a.size3 {padding:3px;font-size:14px;color:#C4876A;}
                    a.size3:hover {color:#E13728;}
                    a.size4 {padding:1px;font-size:18px;color:#B46A47;}
                    a.size4:hover {color:#E13728;}
                    a.size5 {padding:3px;font-size:16px;color:#E13728;}
                    a.size5:hover {color:#B46A47;}
                    a.size6 {padding:2px;font-size:12px;color:#77625E;}
                    a.size6:hover {color:#E13728;}
                </style>
                <div class="tag-cloud-tags" id="tags">
                    <#list init.tags as tag>
                    <a href="${tag.url}">${tag.text}</a>
                </#list>
            </div>
    </div>
    </section>
    <#if init.webSite.duoshuo_status == "on">
    <#include "../../core/duoshuo_comment.ftl">
</#if>
</div>
</div>
<div class="sidebar-toggle">
    <div class="sidebar-toggle-line-wrap">
        <span class="sidebar-toggle-line sidebar-toggle-line-first"></span>
        <span class="sidebar-toggle-line sidebar-toggle-line-middle"></span>
        <span class="sidebar-toggle-line sidebar-toggle-line-last"></span>
    </div>
</div>
<#include "aside.ftl">
<#include "footer.ftl">
