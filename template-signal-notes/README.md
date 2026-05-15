# template-signal-notes AI Maintenance Guide

This file is the source of truth for AI-assisted changes to `template-signal-notes`.

Goal: maintain a ZrLog Freemarker theme inspired by the Next.js Blog layout system, without copying Next.js or Vercel brand assets.

## Non-Negotiable Rules

MUST:
- Keep this as a Freemarker theme under `static/include/templates/template-signal-notes`.
- Preserve the current file split: `page.ftl` for listing, `detail.ftl` for article shell, `article.ftl` for article body, `plugin.ftl` for discovery/resources, `header.ftl` and `footer.ftl` for shell.
- Use existing ZrLog fields listed in this document before introducing any new field.
- Keep homepage and detail markdown rendered through `markdown-body`.
- Keep dark mode driven by the top-level theme state on `<html>`.
- Run validation commands after changes.

MUST NOT:
- Do not add Next.js, Vercel, or other official brand icons/logos.
- Do not restore the old top header triangle icon, slash separator, search shortcut hint, or `Learn` link.
- Do not hotlink external icons, fonts, or images.
- Do not use `65ch` width limits on `.article-body` or detail-page body-adjacent sections.
- Do not show `log.digest` on the detail page.
- Do not let markdown or highlight.js make independent dark-mode decisions.

## Files

Primary files:
- `header.ftl`: document head, nav, search, Deploy link, theme switcher, initial theme script.
- `footer.ftl`: footer and `js/theme-toggle.js` include.
- `page.ftl`: homepage/list page cards.
- `detail.ftl`: article detail header, author, category, detail layout.
- `article.ftl`: article body, tags, source, previous/next.
- `plugin.ftl`: discovery/resources section.
- `css/style.css`: all theme CSS.
- `js/theme-toggle.js`: Light / Dark / System switching.
- `_common/auto-hljs.ftl`: highlight.js CSS links.
- `language/i18n_*.properties`: UI text.
- `template.properties`: theme metadata and `staticResource`.

If adding a new static folder, update `template.properties`.

Current static resources:

```properties
staticResource=css,js
```

## Data Contract

Article/list fields:

| Field | Use |
| --- | --- |
| `log.title` | Article title |
| `log.url` | Article URL |
| `log.digest` | Homepage card markdown summary only |
| `log.content` | Detail page article markdown/HTML body |
| `log.thumbnail` | Homepage card preview image |
| `log.thumbnailAlt` | Preview image alt fallback before title |
| `log.header` | Author avatar |
| `log.userName` | Author name |
| `log.typeName` | Category name |
| `log.typeUrl` | Category URL |
| `log.releaseTime` | Publish time, display as `log.releaseTime?split("T")[0]` |
| `log.tags` | Detail page article tags |
| `log.lastLog` | Previous article |
| `log.nextLog` | Next article |
| `log.noSchemeUrl` | Original/permalink display |
| `log.canComment` | Whether to render comment plugin |

Global fields:

| Field | Use |
| --- | --- |
| `baseUrl` | Home and global assets |
| `url` | Current theme static URL |
| `webs.title` | Site title fallback |
| `webs.description` | Footer description |
| `webs.icp` | ICP footer text |
| `webs.webCm` | Custom hidden footer HTML |
| `init.logNavs` | Top/footer nav links |
| `init.types` | Discovery categories |
| `init.archiveList` | Discovery archives |
| `init.tags` | Discovery tags |
| `init.links` | Discovery external links |
| `_res.*` | i18n and theme config text |

## Homepage Rules

File: `page.ftl`

Required behavior:
- Render cards in masonry layout using CSS columns.
- Use `log.thumbnail` for card preview image.
- Use `log.header` for author avatar; fallback to circular placeholder.
- Render card summary as markdown:

```ftl
<div class="markdown-body post-card__prose">${log.digest!''}</div>
```

- Show category using `log.typeName` and optional `log.typeUrl`.
- Use the shared `.category-icon` for category display.

CSS requirements:
- `.posts-grid` uses `column-width` / `column-gap`.
- `.post-card` uses `display: inline-flex` and `break-inside: avoid`.
- Mobile forces one column.
- Card markdown styles must be scoped under `.post-card__prose`.

## Detail Page Rules

Files: `detail.ftl`, `article.ftl`

Required behavior:
- Do not render `log.digest` on detail pages.
- Render article body only through:

```ftl
<div class="markdown-body article-body">${log.content!''}</div>
```

- Use `log.header` for author avatar; fallback to circular placeholder.
- Show category using `log.typeName` and optional `log.typeUrl`.
- Use the shared `.category-icon` for category display.
- Use `.article-tag` for detail article tags.
- Do not use `.tag-chip` for detail article tags.

Width rules:
- Detail shell stays around `860px`.
- `.article-body`, tags, source, previous/next, and comments follow the detail container width.
- Do not add `max-width: 65ch` back to these areas.

## Header Rules

File: `header.ftl`

Allowed:
- Text brand only.
- Nav links from `init.logNavs`.
- Search input.
- Optional Deploy link from `_res['githubLink']`.
- Theme switcher.

Forbidden:
- Next.js / Vercel logo or icon.
- Triangle logo.
- Slash separator.
- Search shortcut hint such as `⌘K`.
- `Learn` link beside the controls.

Control styling:
- Search and theme switcher must look like one control family.
- Use `32px` height, `6px` radius, gray background, consistent hover/focus.
- Do not make the theme switcher a visually separate large pill.

## Dark Mode Rules

Files: `header.ftl`, `_common/auto-hljs.ftl`, `js/theme-toggle.js`, `css/style.css`

Theme modes:
- `light`
- `dark`
- `system`

Storage:

```js
localStorage["signal-notes-theme"]
```

HTML attributes:
- `data-theme`: set only for manual `light` or `dark`.
- `data-theme-mode`: current selected mode, including `system`.
- `data-theme-effective`: computed actual theme, `light` or `dark`.

CSS rule:
- Dark CSS variables must be under:

```css
:root[data-theme-effective="dark"] { ... }
```

Highlight.js rule:
- `_common/auto-hljs.ftl` must keep both hljs links disabled by default:

```html
media="not all"
```

- Header initialization and `js/theme-toggle.js` choose the correct hljs stylesheet based on `data-theme-effective`.
- Do not use `prefers-color-scheme` directly in the hljs link media attributes.

## Markdown Rules

Homepage:
- `log.digest` is markdown.
- Render with `markdown-body post-card__prose`.
- Keep card markdown overrides scoped to `.post-card__prose`.

Detail:
- `log.content` is markdown/HTML body.
- Render with `markdown-body article-body`.
- Keep detail markdown overrides scoped to `.article-body`.

Dark mode:
- Markdown colors must inherit from theme CSS variables.
- Do not allow global `markdown.css` light table/border/code styles to dominate in dark mode.

## Category Icon Rules

Shared icon class:

```html
<span class="category-icon" aria-hidden="true"></span>
```

Use this class in both:
- Homepage category: `.post-card__category`
- Detail category: `.article-author.article-author--category`

Do not create page-specific category icon classes unless there is a strong reason.

## Discovery Section Rules

File: `plugin.ftl`

Purpose: lightweight resources section, not a sidebar dashboard.

Required style:
- Footer/resources-like link columns.
- Small headings and lightweight links.
- No large cards, no heavy shadows, no big marketing block.
- Tag links here may use `.tag-chip`; detail article tags must not.

## Common Change Recipes

Add a new UI string:
1. Add key to both `language/i18n_zh_CN.properties` and `language/i18n_en_US.properties`.
2. Read it with fallback: `${_res.key!'Fallback'}`.

Add a new static JS file:
1. Put file under `js/`.
2. Include it from `footer.ftl` unless it must run before paint.
3. Ensure `template.properties` includes `js`.
4. Run `node --check` for changed JS.

Change card layout:
1. Edit `page.ftl` structure only if necessary.
2. Keep `.posts-grid` masonry behavior.
3. Keep thumbnail, category, avatar, markdown summary.
4. Check mobile single-column behavior.

Change detail layout:
1. Edit `detail.ftl` for header metadata.
2. Edit `article.ftl` for body-adjacent content.
3. Do not reintroduce digest lead text.
4. Do not reintroduce `65ch` detail body limits.

## Validation

Always run:

```bash
mvn -q -DskipTests compile
```

If `js/theme-toggle.js` changed, also run:

```bash
node --check static/include/templates/template-signal-notes/js/theme-toggle.js
```

Manual checks:
- Homepage: masonry, thumbnail, category icon, avatar, markdown summary, dark mode.
- Detail: no digest lead, author avatar, category icon, markdown body, tags, comments, dark mode.
- Header: no official brand icon, no shortcut hint, no Learn link, consistent search/theme controls.
