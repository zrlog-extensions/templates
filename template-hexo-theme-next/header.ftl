<!doctype html>
<html>
<head>
    <#assign webs = init.webSite>
    <title><#if log??>${log.title} - </#if>${webs.title} - ${webs.second_title}</title>
    <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
    <meta name="description" content="${webs.description!''}"/>
    <#if log?? && log.keywords??>
        <meta name="keywords" content="${log.keywords!''}"/>
    <#else>
        <meta name="keywords" content="${webs.keywords!''}"/>
    </#if>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <link rel="stylesheet" type="text/css" media="screen" href="${templateUrl!}/css/editormd.css" />
    <link href="${templateUrl!}/css/main.css?v=5.1.0" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="container one-collumn sidebar-position-left page-home">
    <div class="headband"></div>
    <header id="header" class="header">
        <div class="header-inner"><div class="site-meta">
            <div class="custom-logo-site-title" id="navbar">
                <a href="/" class="brand" rel="start" style="opacity: 1;">
                    <span class="logo-line-before"><i></i></span>
                    <span class="site-title" style="opacity: 1; top: 0px;">${webs.title!}</span>
                    <span class="logo-line-after"><i></i></span>
                </a>
            </div>
            <p class="site-subtitle" style="opacity: 1; top: 0px;">${webs.second_title!}</p>
        </div>
            <div class="site-nav-toggle">
                <button>
                    <span class="btn-bar"></span>
                    <span class="btn-bar"></span>
                    <span class="btn-bar"></span>
                </button>
            </div>
            <nav class="site-nav">
                <ul id="menu" class="menu">
                    <#list init.logNavs as lognav>
                    <#if lognav.current>
                    <li class="menu-item activem enu-item-home menu-item-active" style="opacity: 1; transform: translateY(0px);" ><a href="${lognav.url!}">${lognav.navName!}</a></li>
                    <#else>
                    <li class="menu-item menu-item-home " style="opacity: 1; transform: translateY(0px);"><a href="${lognav.url!}">${lognav.navName!}</a></li>
                </#if>
            </#list>
            </ul>
            </nav>
        </div>
        <#include "aside.ftl"/>
    </header>
    <main id="main" class="main">
        <div class="main-inner">