<%@ page language="java" session="false" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<aside id="sidebar" class="sidebar" style="margin-top: 296px; display: block;">
<div class="sidebar-inner">
  <section class="site-overview sidebar-panel  sidebar-panel-active ">
    <div class="site-author motion-element">
      <img class="site-author-image" src="${_res.avatar}" alt="${_res.internetName}">
      <p class="site-author-name">${_res.internetName}</p>
      <p class="site-description motion-element">${_res.slogan}</p>
    </div>
    <nav class="site-state motion-element">
      <div class="site-state-item site-state-posts">
          <span class="site-state-item-count">${init.statistics.totalArticleSize}</span>
          <span class="site-state-item-name">日志</span>
      </div>
        <div class="site-state-item site-state-categories">
            <span class="site-state-item-count">${init.statistics.totalTypeSize}</span>
            <span class="site-state-item-name">分类</span>
        </div>
        <div class="site-state-item site-state-tags">
          <a href="${rurl}post/tags">
            <span class="site-state-item-count">${init.statistics.totalTagSize}</span>
            <span class="site-state-item-name">标签</span>
          </a>
        </div>
    </nav>
    <div class="motion-element search">
    <style>
    .cf:before, .cf:after{
        content:"";
        display:table;
    }

    .cf:after{
        clear:both;
    }

    .cf{
        zoom:1;
    }

     /* Form wrapper styling */
    .search-wrapper {
    width: 220px;
    margin: 30px auto 30px auto;
    box-shadow: 0 1px 1px rgba(0, 0, 0, .4) inset, 0 1px 0 rgba(255, 255, 255, .2);
    }

    /* Form text input */

    .search-wrapper input {
    width: 138px;
    height: 20px;
    padding: 10px 5px;
    float: left;
    border: 0;
    background: #EEE;
    border-radius: 1px 0 0 1px;
    }

    .search-wrapper input:focus {
        outline: 0;
        background: #fff;
        box-shadow: 0 0 2px rgba(0,0,0,.8) inset;
    }

    .search-wrapper input::-webkit-input-placeholder {
       color: #999;
       font-weight: normal;
       font-style: italic;
    }

    .search-wrapper input:-moz-placeholder {
        color: #999;
        font-weight: normal;
        font-style: italic;
    }

    .search-wrapper input:-ms-input-placeholder {
        color: #999;
        font-weight: normal;
        font-style: italic;
    }

    /* Form submit button */
    .search-wrapper button {
    overflow: visible;
    position: relative;
    float: right;
    border: 0;
    padding: 0;
    cursor: pointer;
    height: 40px;
    width: 72px;
    border-radius: 1px 0 0 1px;
    color: white;
    text-transform: uppercase;
    background: #222;
    text-shadow: 0 -1px 0 rgba(0, 0, 0, .3);
    }

    .search-wrapper button:hover{
        background: #e54040;
    }

    .search-wrapper button:active,
    .search-wrapper button:focus{
        background: #c42f2f;
        outline: 0;
    }

    .search-wrapper button:before { /* left arrow */
        content: '';
        position: absolute;
        border-width: 8px 8px 8px 0;
        border-style: solid solid solid none;
        border-color: transparent #222 transparent;
        top: 12px;
        left: -6px;
    }

    .search-wrapper button:hover:before{
        border-right-color: #e54040;
    }

    .search-wrapper button:focus:before,
    .search-wrapper button:active:before{
            border-right-color: #c42f2f;
    }

    .search-wrapper button::-moz-focus-inner { /* remove extra button spacing for Mozilla Firefox */
        border: 0;
        padding: 0;
    }
    </style>
        <form action="${searchUrl}" class="search-wrapper cf" method="post">
                <input type="text" placeholder="${_res.searchTip}" value="${key}" name="key" title="${_res.searchTip}" required="">
                <button type="submit">${_res.search}</button>
            </form>
    </div>
   <div class="links-of-author motion-element">
        <c:if test="${not empty _res.githubLink}">
          <span class="links-of-author-item">
            <a href="${_res.githubLink}" target="_blank" title="GitHub">
                <i class="fa fa-fw fa-github"></i>
              GitHub
            </a>
          </span>
          </c:if>
          <c:if test="${not empty _res.twitterLink}">
          <span class="links-of-author-item">
            <a href="${_res.twitterLink}" target="_blank" title="Twitter">

                <i class="fa fa-fw fa-twitter"></i>

              Twitter
            </a>
          </span>
          </c:if>
            <c:if test="${not empty _res.doubanLink}">
          <span class="links-of-author-item">
            <a href="${_res.doubanLink}" target="_blank" title="豆瓣">

                <i class="fa fa-fw fa-globe"></i>

              豆瓣
            </a>
          </span>
           </c:if>
            <c:if test="${not empty _res.zhihuLink}">
          <span class="links-of-author-item">
            <a href="${_res.zhihuLink}" target="_blank" title="知乎">

                <i class="fa fa-fw fa-globe"></i>

              知乎
            </a>
          </span>
           </c:if>
    </div>
  </section>
</div>
</aside>