# BrowserOS Skill

BrowserOS is the primary browser tool for OpenClaw when a real logged-in browser session or bot-resistant page is needed.

MCP endpoint:
- `http://127.0.0.1:9000/mcp`
- BrowserOS may auto-discover and save a different local MCP port after `browseros-cli init --auto`

The BrowserOS CLI maps the full MCP surface, so this skill should be treated as full-featured browser control.

## What this skill is for
Use BrowserOS when you need:
- X/Twitter or other social media browsing
- login-required pages
- Cloudflare/protected/blocked sites
- persistent browser sessions
- screenshots, text extraction, snapshots, clicks, fills, uploads, and downloads
- a browser workflow that is stronger than simple web fetches

## Quick start
1. Start BrowserOS.
2. Run `browseros-cli health`.
3. Run `browseros-cli init --auto` if needed.
4. Use the CLI to open or navigate pages.
5. Extract text, take snapshots, or interact with the page.
6. Close pages when finished.

## Install / init
If the CLI is not available:
```bash
curl -fsSL https://cdn.browseros.com/cli/install.sh | bash
```

After install, the binary may live at `~/.browseros/bin/browseros-cli` until your PATH is refreshed.

Then initialize it:
```bash
browseros-cli init --auto
browseros-cli health
browseros-cli status
```

If BrowserOS is already installed but unhealthy, restart the app and re-run auto-init.
On macOS, start the app with:
```bash
open -a BrowserOS
```

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

## Wrapper script
A helper wrapper is available at:
- `scripts/browseros.sh`

It provides a lightweight health check and falls back to `browseros-cli` when available.

## Best practices
- Prefer BrowserOS for blocked or session-sensitive sites.
- Verify health before using it.
- Close tabs when done to reduce memory pressure.
- Don’t hardcode the MCP port; BrowserOS may expose a different one in some installs.
- Use `browseros-cli init --auto` to discover and save the live MCP URL.
- Use `text` or `snap` before clicking when the target is ambiguous.
- If memory grows over a long browsing session, restart BrowserOS rather than keeping a leaky instance alive.

## Desktop copy
A Desktop copy of this skill is kept at:
- `~/Desktop/BrowserOS/`

## OpenClaw integration
- MCP endpoint: `http://127.0.0.1:9000/mcp` (auto-discovered ports may vary)
- Wrapper script: `scripts/browseros.sh`
- Health check: `browseros-cli health`
- Auto-init: `browseros-cli init --auto`
- Fallback chain: BrowserOS CLI/MCP → BrowserOS app → generic browser tooling → web fetch
