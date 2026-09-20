<!DOCTYPE html>
<html lang="${lang!'en'}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${(title!'')?html}</title>
<meta name="description" content="${(description!'')?html}">
<link rel="stylesheet" href="${baseUrl}assets/css/markdown.css">
<link rel="stylesheet" href="${baseUrl}assets/css/pretty-print.css">
<link rel="stylesheet" href="${baseUrl}assets/css/katex.min.css">
<link rel="stylesheet" href="${baseUrl}assets/css/hljs/light.css">
<link rel="stylesheet" href="${url}/css/style.css">
</head>
<body>
<header class="shell">
<a href="${baseUrl}">${(webs.title!'')?html}</a>
<nav aria-label="${(_res.navigation!'Navigation')?html}">
<#list init.logNavs as nav><a href="${nav.url?html}">${nav.navName?html}</a></#list>
</nav>
<form action="${searchUrl}" method="post">
<label>${_res.search!'Search'} <input name="key" value="${(key!'')?html}"></label>
<button type="submit">${_res.search!'Search'}</button>
</form>
</header>
<main class="shell">
