<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="utf-8"/>

    <#assign webs = init.webSite>
    <title><#if log??>${log.title} - </#if>${webs.title} - ${webs.second_title}</title>
    <link rel="shortcut icon" type="image/x-icon" href="${baseUrl}favicon.ico"/>
    <meta name="description" content="${webs.description!''}"/>
    <#if log?? && log.keywords??>
        <meta name="keywords" content="${log.keywords!''}"/>
    <#else>
        <meta name="keywords" content="${webs.keywords!''}"/>
    </#if>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
    <link rel="stylesheet" type="text/css" href="${baseUrl}assets/css/video-js.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="${templateUrl}/css/style.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="${templateUrl}/css/editormd.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="${baseUrl}assets/css/katex.min.css"/>
    <script src="${templateUrl}/js/jquery.min.js"></script>
    <script src="${templateUrl}/js/sheshui.js"></script>
    <script src="${baseUrl}assets/js/video.js"></script>
    <style>
        header .avatar {
            background: url("${_res["avatar"]!''}") scroll center center #FFFFFF;
            background-size: cover;
            width: 60px;
            height: 60px;
        }

        .gn-menu-main li.sitename .gn-icon {
            width: 50px;
            height: 50px;
            margin-top: 10px;
            border-radius: 50%;
            background: url("${_res["avatar"]!''}") no-repeat center center;
            display: inline-block;
            background-size: cover;
        }

        .markdown-body ul, .markdown-body ol {
            padding-left: 0;
        }
    </style>
</head>
<body>
<div class="page">
    <div class="top">
        <div class="inner">
            <header>
                <h1 class="site-name">
                    <i class="avatar"></i>
                    <a title="${_res["title"]}" href="${rurl}">${_res["title"]}</a>
                    <span class="slogan">${website["title"]}</span>
                </h1>
                <nav class="mainnav">
                    <ul class="section_list">
                        <#list init.logNavs as lognav>
                        <#if lognav.current>
                        <li class="active"><a href="${lognav.url}">${lognav.navName}</a></li>
                        <#else>
                        <li><a href="${lognav.url}">${lognav.navName}</a></li>
                    </#if>
                </#list>
                </ul>
                </nav>
                <ul id="gn-menu" class="gn-menu-main">
                    <li class="gn-trigger">
                        <a class="gn-icon gn-icon-menu"></a>
                        <nav class="gn-menu-wrapper">
                            <div class="gn-scroller">
                                <ul class="gn-menu">
                                    <li class="gn-search-item">
                                        <form method="post" action="${rurl}search"><input
                                                placeholder="${_res["searchTip"]}" type="search" name="key"
                                                class="gn-search">
                                            <a class="gn-icon icon-search"><span>${_res["search"]}</span></a></form>
                                    </li>
                                    <li>
                                        <a class="gn-icon icon-article">${_res["category"]}</a>
                                        <ul class="gn-submenu">
                                            <#list init.types as type>
                                            <li><a class="gn-icon icon-star"
                                                   href="${type.url}">${type.typeName}
                                                (${type.typeamount})</a></li>
                                        </#list>
                                </ul>
                    </li>
                </ul>
        </div>
        </nav>
        </li>
        <li class="sitename">
            <a class="gn-icon icon-info" href="${rurl}"></a>
        </li>
        </ul>
        </header>
    </div>
</div>
<div class="breadcrumb"></div>
<div class="main clearfloat">
