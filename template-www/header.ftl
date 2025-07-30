<!DOCTYPE html>
<html lang="${lang!''}">
<head>
    <meta charset="utf-8"/>
    <title>${title!''}</title>
    <link rel="shortcut icon" type="image/x-icon" href="${baseUrl}favicon.ico"/>
    <meta name="description" content="${description!''}"/>
    <meta name="keywords" content="${keywords!''}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
    <link rel="shortcut icon" type="image/svg+xml" href="${baseUrl }/favicon.svg"/>
    <link href="${url}/fonts/remixicon.css" rel="stylesheet"/>
    <link href="${url}/css/editormd.css" rel="stylesheet"/>
    <#include "_common/auto-hljs.ftl"/>
    <script src="${url}/js/tailwindcss-3.4.6.js"></script>

    <script>tailwind.config = {
            darkMode: 'class', // ✅ 启用暗黑模式（class 模式）
            theme: {
                extend: {
                    colors: {primary: '${_res['colorPrimary']!'#1677ff'}', secondary: '#f97316'},
                    borderRadius: {
                        'none': '0px',
                        'sm': '4px',
                        DEFAULT: '8px',
                        'md': '12px',
                        'lg': '16px',
                        'xl': '20px',
                        '2xl': '24px',
                        '3xl': '32px',
                        'full': '9999px',
                        'button': '8px'
                    }
                }
            }
        }
    </script>
    <script src="${url}/js/helpers.js"></script>
    <style>
        :where([class^="ri-"])::before {
            content: "\f3c2";
        }

        body {
            font-family: 'Inter', 'PingFang SC', 'Microsoft YaHei', sans-serif;
        }

        :root {
            --color-primary: ${_res['colorPrimary']!'#1677ff'};
        }

        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .theme-switch {
            position: relative;
            width: 60px;
            height: 30px;
        }

        .theme-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #2b2b2b;
            transition: .4s;
            border-radius: 30px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 22px;
            width: 22px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: var(--color-primary);
        }

        input:checked + .slider:before {
            transform: translateX(30px);
        }


        .nav-active {
            font-weight: 500;
            color: var(--color-primary);
        }

        .markdown-body ul li {
            list-style: outside;
        }

        .markdown-body ol li {
            list-style: decimal;
        }
        .markdown-body pre {
            padding: 0 !important;
        }

        .markdown-body a {
            color: var(--color-primary);
        }

    </style>
    ${globalStyle!''}
</head>
<body class="dark:bg-black dark:text-gray-200">
<!-- 导航栏 -->
<nav class="bg-gray-900 text-white py-4" id="header">
    <div class="container mx-auto px-4 md:px-6 flex items-center justify-between">
        <div class="flex items-center">
            <a href="/" class="text-xl font-bold mr-10">${_res['navBarBrand']!''}</a>
            <ul class="hidden md:flex space-x-6">
                <#include "header-nav.ftl"/>
            </ul>
        </div>
        <div id="overlay"
             class="fixed inset-0 bg-black bg-opacity-50 z-30 hidden"></div>
        <aside id="sidebar" class="fixed text-white top-0 bg-primary left-0 w-56 h-full bg-gray-100 dark:bg-gray-800 text-black dark:text-white p-6
           -translate-x-full transition-transform duration-300 z-40 hidden"
               style="background: rgb(17 24 39);">
            <ul class="space-y-6" style="font-size: 18px;text-align: center;">
                <#include "header-nav.ftl"/>
            </ul>
        </aside>
        <div class="flex items-center space-x-4">
            ${_res['githubLink']!''}
            <label class="theme-switch">
                <input type="checkbox">
                <span class="slider"></span>
            </label>
            <button class="md:hidden flex items-center justify-center w-8 h-8" id="toggleSidebar">
                <i class="ri-menu-line ri-lg"></i>
            </button>
        </div>
    </div>
</nav>