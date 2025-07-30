<!DOCTYPE html>
<html lang="${lang!''}">
<head>
    <#include "_common/meta.ftl"/>
    <link href="${url}/fonts/remixicon.css" rel="stylesheet"/>
    <link href="${url}/css/editormd.css" rel="stylesheet"/>
    <#include "_common/auto-hljs.ftl"/>
    <style>
        :root {
            --color-primary: ${_res['colorPrimary']!'#1677ff'};
        }
    </style>
    ${globalStyle!''}
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