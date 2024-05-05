<!DOCTYPE>
<html lang="${lang}">
<head>
    <meta charset="utf-8"/>
    <link rel="shortcut icon" type="image/x-icon" href="${rurl}/favicon.ico"/>
    <meta name="description" content="${webs.description}"/>
    <#if log?? && log.keywords??>
        <meta name="keywords" content="${log.keywords!''}"/>
    <#else>
        <meta name="keywords" content="${webs.keywords!''}"/>
    </#if>
    <title><#if log??>${log.title} - </#if>${webs.title} - ${webs.second_title}</title>
    <link rel="stylesheet" type="text/css" href="${url}/css/editormd.css"/>
    <link type="text/css" href="${url}/css/style.css" rel="stylesheet"/>
    <script type="text/javascript" src="${url}/js/html5.js"></script>
    <script type="text/javascript" src="${url}/js/jquery-1.4.2.min.js"></script>
    <style>
        .entry-header .comments-link a {
            background: #eee url(${url}/images/comment-bubble.png) no-repeat;
        }
        #branding {
            background: url(${url}/images/bg.bmp);
        }
        input#s {
            background: url(${url}/images/search.png) no-repeat 5px 6px;
        }
        .commentlist > li:before {
            content: url(${url}/images/comment-arrow.png);
        }
        .commentlist > li.bypostauthor:before {
            content: url(${url}/images/comment-arrow-bypostauthor.png);
        }
    </style>
</head>
<body><div class="hfeed" id="page">
<#include "nav.ftl">