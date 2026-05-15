(function () {
    "use strict";

    var storageKey = "signal-notes-theme";
    var root = document.documentElement;
    var mediaQuery = window.matchMedia ? window.matchMedia("(prefers-color-scheme: dark)") : null;

    function normalizeTheme(theme) {
        if (theme === "light" || theme === "dark") {
            return theme;
        }
        return "system";
    }

    function readTheme() {
        try {
            return normalizeTheme(localStorage.getItem(storageKey));
        } catch (error) {
            return "system";
        }
    }

    function writeTheme(theme) {
        try {
            if (theme === "system") {
                localStorage.removeItem(storageKey);
                return;
            }
            localStorage.setItem(storageKey, theme);
        } catch (error) {
            return;
        }
    }

    function getEffectiveTheme(theme) {
        if (theme === "system") {
            return mediaQuery && mediaQuery.matches ? "dark" : "light";
        }
        return theme;
    }

    function updateButtons(theme) {
        var buttons = document.querySelectorAll("[data-theme-choice]");
        Array.prototype.forEach.call(buttons, function (button) {
            var active = button.getAttribute("data-theme-choice") === theme;
            button.setAttribute("aria-pressed", active ? "true" : "false");
        });
    }

    function updateCodeHighlightTheme(theme) {
        var light = document.getElementById("signal-notes-hljs-light");
        var dark = document.getElementById("signal-notes-hljs-dark");
        if (!light || !dark) {
            return;
        }
        var effectiveTheme = getEffectiveTheme(theme);
        light.media = effectiveTheme === "light" ? "all" : "not all";
        dark.media = effectiveTheme === "dark" ? "all" : "not all";
    }

    function applyTheme(theme) {
        var normalizedTheme = normalizeTheme(theme);
        if (normalizedTheme === "system") {
            root.removeAttribute("data-theme");
        } else {
            root.setAttribute("data-theme", normalizedTheme);
        }
        root.setAttribute("data-theme-mode", normalizedTheme);
        root.setAttribute("data-theme-effective", getEffectiveTheme(normalizedTheme));
        updateButtons(normalizedTheme);
        updateCodeHighlightTheme(normalizedTheme);
    }

    document.addEventListener("click", function (event) {
        var target = event.target;
        if (!target || !target.closest) {
            return;
        }
        var button = target.closest("[data-theme-choice]");
        if (!button) {
            return;
        }
        var theme = normalizeTheme(button.getAttribute("data-theme-choice"));
        writeTheme(theme);
        applyTheme(theme);
    });

    if (mediaQuery) {
        var handleSystemThemeChange = function () {
            if (readTheme() === "system") {
                applyTheme("system");
            }
        };
        if (mediaQuery.addEventListener) {
            mediaQuery.addEventListener("change", handleSystemThemeChange);
        } else if (mediaQuery.addListener) {
            mediaQuery.addListener(handleSystemThemeChange);
        }
    }

    applyTheme(readTheme());
})();
