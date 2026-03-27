---
name: browseros
description: Use BrowserOS as the primary browser tool in OpenClaw for local browser automation, blocked sites, login sessions, and social media. Use when you need to start BrowserOS, verify its MCP health, open URLs, navigate pages, inspect content, take snapshots, click, fill forms, or extract text through the BrowserOS CLI/MCP bridge.
---

# BrowserOS

BrowserOS is the preferred browser tool for OpenClaw when a real logged-in browser session or bot-resistant page is needed.
BrowserOS MCP endpoint: `http://127.0.0.1:9000/mcp` (or the live port reported by BrowserOS after auto-init).
BrowserOS CLI is the primary bridge for browser control; use it when available.

## Use this skill when
- The task involves X/Twitter, social media, login walls, Cloudflare, or blocked pages
- You need a persistent local browser session
- You need screenshots, page text, snapshots, clicks, form fills, uploads, or downloads
- You want BrowserOS to be used instead of generic web fetch/browser tooling

## Quick flow
1. Start BrowserOS if needed.
2. Run `browseros-cli health`.
3. Run `browseros-cli init --auto` if the endpoint is missing or stale.
4. Open or navigate to a page.
5. Extract text, take snapshots, or interact with the page.
6. Close tabs when finished.

## Install / init
If the CLI is not available:
```bash
curl -fsSL https://cdn.browseros.com/cli/install.sh | bash
```

After install, the binary may live at `~/.browseros/bin/browseros-cli` until PATH is refreshed.

Then initialize it:
```bash
browseros-cli init --auto
browseros-cli health
browseros-cli status
```

If BrowserOS is already installed but unhealthy, restart the app and re-run auto-init.
On macOS, the app is typically started with:
```bash
open -a BrowserOS
```

## Wrapper script
A helper wrapper is available at:
- `scripts/browseros.sh`

Use it for repeatable health checks or as a thin helper around `browseros-cli`.

## Core commands
```bash
browseros-cli health
browseros-cli status
browseros-cli pages
browseros-cli active
browseros-cli open https://example.com
browseros-cli nav https://example.com
browseros-cli back
browseros-cli forward
browseros-cli reload
browseros-cli snap
browseros-cli snap -e
browseros-cli text
browseros-cli links
browseros-cli eval "document.title"
browseros-cli click e5
browseros-cli click-at 100 200
browseros-cli fill e12 "hello"
browseros-cli key Enter
browseros-cli hover e3
browseros-cli scroll down 500
browseros-cli drag e2 e9
browseros-cli upload /path/to/file
browseros-cli select e4 "Option"
browseros-cli checkbox e7
browseros-cli dialog
browseros-cli wait
browseros-cli dom
browseros-cli dom-search "text"
browseros-cli ss -o shot.png
browseros-cli pdf -o page.pdf
browseros-cli window list
browseros-cli bookmark search "github"
browseros-cli history recent
browseros-cli group list
browseros-cli hidden list
browseros-cli info
```

## MCP bridge notes
- The BrowserOS CLI should discover and persist the live MCP URL after `init --auto`.
- Do not hardcode only one port; BrowserOS may expose a different local port in some installs.
- If `browseros-cli health` fails but the app is running, try `browseros-cli init --auto` again before falling back.
- If the MCP endpoint is unreachable, prefer restarting BrowserOS over manually editing URLs.

## Interaction rules
- Prefer opening a fresh page for each task.
- Use snapshot/content before clicking when the target is ambiguous.
- Use text extraction for lightweight reading.
- Use screenshots when visual confirmation matters.
- Close or recycle tabs after use to keep the session tidy.
- Prefer `snap -e` / `dom-search` when you need stable refs before clicking or filling.

## Full feature coverage
BrowserOS CLI/MCP is intended to cover the full browser surface, including:
- pages and active tab control
- navigation and history
- snapshots, screenshots, text extraction, links, eval, and DOM search
- clicks, fills, key presses, hover, scroll, drag, upload, focus, select, checkbox interaction
- dialogs, waits, and JS evaluation
- windows, bookmarks, history, groups, and hidden tabs
- file export/download and PDF capture
- status, info, and health commands
- session persistence for login-sensitive work
- tab lifecycle management and page cleanup

If a browser task exists, prefer BrowserOS CLI/MCP first.

## OpenClaw integration
- MCP endpoint: `http://127.0.0.1:9000/mcp` (live port may vary; auto-init should discover it)
- Wrapper script: `scripts/browseros.sh`
- Health check: `browseros-cli health`
- Auto-init: `browseros-cli init --auto`
- Fallback chain: BrowserOS CLI/MCP → BrowserOS app → generic browser tooling → web fetch

## Maintenance and memory guidance
- BrowserOS can leak memory over long sessions; restart periodically if tabs/processes grow.
- Prefer closing tabs after tasks instead of leaving them idle.
- If memory climbs after a long browsing session, restart BrowserOS rather than trying to nurse the same instance forever.
- If the CLI is missing from PATH, use `~/.browseros/bin/browseros-cli` directly.

## Suggested test plan
1. `browseros-cli health`
2. `browseros-cli status`
3. `browseros-cli open https://example.com`
4. `browseros-cli snap`
5. `browseros-cli text`
6. `browseros-cli click` or `fill` on a known element
7. `browseros-cli ss -o /tmp/browseros-test.png`
8. `browseros-cli pdf -o /tmp/browseros-test.pdf`
9. Close or clean up tabs
10. Verify BrowserOS still passes `health` after the workflow

## Desktop copy
A Desktop copy of this skill should be kept at `~/Desktop/BrowserOS/` for manual review and quick access.
