<!DOCTYPE html>
<html lang="${lang!''}">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="color-scheme" content="light dark"/>
    <#include "_common/meta.ftl"/>
    <script>
        (function () {
            var root = document.documentElement;
            var theme = "system";
            var effectiveTheme = "light";
            try {
                var storedTheme = localStorage.getItem("signal-notes-theme");
                if (storedTheme === "light" || storedTheme === "dark") {
                    theme = storedTheme;
                }
                effectiveTheme = theme === "system"
                    ? window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
                    : theme;
                if (theme === "light" || theme === "dark") {
                    root.setAttribute("data-theme", theme);
                } else {
                    root.removeAttribute("data-theme");
                }
            } catch (error) {
                root.removeAttribute("data-theme");
            }
            root.setAttribute("data-theme-mode", theme);
            root.setAttribute("data-theme-effective", effectiveTheme);
        })();
    </script>
    <link rel="stylesheet" href="${baseUrl}assets/css/markdown.css"/>
    <link rel="stylesheet" href="${baseUrl}assets/css/pretty-print.css"/>
    <link rel="stylesheet" href="${baseUrl}assets/css/katex.min.css"/>
    <#include "_common/auto-hljs.ftl"/>
    <script>
        (function () {
            try {
                var effectiveTheme = document.documentElement.getAttribute("data-theme-effective") || "light";
                var light = document.getElementById("signal-notes-hljs-light");
                var dark = document.getElementById("signal-notes-hljs-dark");
                if (light && dark) {
                    light.media = effectiveTheme === "light" ? "all" : "not all";
                    dark.media = effectiveTheme === "dark" ? "all" : "not all";
                }
            } catch (error) {
                return;
            }
        })();
    </script>
    <link rel="stylesheet" href="${url}/css/style.css"/>
    <style>
        :root {
            --accent: ${_res['colorAccent']!'#0070f3'};
        }
    </style>
    ${_res.globalStyle!''}
</head>
<body>
<header class="site-header">
    <div class="shell site-header__inner">
        <div class="site-header__primary">
            <a class="brand" href="${baseUrl}">
                <span class="brand__text">${_res['navBarBrand']!webs.title!''}</span>
            </a>
            <nav class="site-nav">
                <#list init.logNavs as nav>
                    <a class="site-nav__link<#if nav.current> is-current</#if>" href="${nav.url}">${nav.navName}</a>
                </#list>
            </nav>
        </div>
        <div class="site-header__actions">
            <form class="site-search" action="${searchUrl}" method="post">
                <input class="site-search__input" name="key" type="text" value="${key!''}" placeholder="${_res.searchTip!'Search documentation...'}"/>
            </form>
            <#if _res['githubLink']?has_content>
                <a class="site-header__deploy" href="${_res['githubLink']}" target="_blank" rel="noopener">Deploy</a>
            </#if>
            <div class="theme-switcher" role="group" aria-label="${_res.themeSwitcher!'Theme'}">
                <button class="theme-switcher__button" type="button" data-theme-choice="light" aria-label="${_res.themeLight!'Light'}" title="${_res.themeLight!'Light'}" aria-pressed="false">
                    <span class="theme-switcher__icon theme-switcher__icon--light" aria-hidden="true"></span>
                </button>
                <button class="theme-switcher__button" type="button" data-theme-choice="dark" aria-label="${_res.themeDark!'Dark'}" title="${_res.themeDark!'Dark'}" aria-pressed="false">
                    <span class="theme-switcher__icon theme-switcher__icon--dark" aria-hidden="true"></span>
                </button>
                <button class="theme-switcher__button" type="button" data-theme-choice="system" aria-label="${_res.themeSystem!'System'}" title="${_res.themeSystem!'System'}" aria-pressed="true">
                    <span class="theme-switcher__icon theme-switcher__icon--system" aria-hidden="true"></span>
                </button>
            </div>
        </div>
    </div>
</header>
<main class="site-main">
