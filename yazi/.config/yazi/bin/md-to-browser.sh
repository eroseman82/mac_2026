#!/bin/sh
set -e

src="$1"
[ -z "$src" ] && { echo "usage: md-to-browser.sh <file.md>"; exit 1; }

base=$(basename "$src" .md)
out="/tmp/yazi-md-${base}.html"

read -r -d '' CSS <<'EOF' || true
body { max-width: none !important; margin: 0 !important; padding: 2em 4em !important;
       font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
       line-height: 1.6; color: #24292f; background: #ffffff; }
h1, h2, h3, h4 { border-bottom: 1px solid #d0d7de; padding-bottom: .3em; margin-top: 1.5em; }
h1 { font-size: 2em; } h2 { font-size: 1.5em; } h3 { font-size: 1.25em; }
a { color: #0969da; text-decoration: none; } a:hover { text-decoration: underline; }
code { background: #f6f8fa; padding: .2em .4em; border-radius: 6px; font-size: 85%;
       font-family: "SF Mono", Menlo, Consolas, monospace; }
pre { background: #f6f8fa; padding: 1em; border-radius: 6px; overflow: auto; }
pre code { background: transparent; padding: 0; }
blockquote { color: #57606a; border-left: .25em solid #d0d7de; padding: 0 1em; margin: 0; }
table { border-collapse: collapse; } th, td { border: 1px solid #d0d7de; padding: 6px 13px; }
img { max-width: 100%; }
@media (prefers-color-scheme: dark) {
  body { background: #0d1117; color: #c9d1d9; }
  h1, h2, h3, h4 { border-bottom-color: #30363d; }
  a { color: #58a6ff; }
  code, pre { background: #161b22; }
  blockquote { color: #8b949e; border-left-color: #30363d; }
  th, td { border-color: #30363d; }
}
EOF

style_file=$(mktemp -t yazi-md-style).css
printf '<style>%s</style>' "$CSS" > "$style_file"

pandoc --standalone --metadata title="$(basename "$src")" \
  --include-in-header="$style_file" \
  -f gfm -t html "$src" -o "$out"

rm -f "$style_file"
open -a "Google Chrome" "$out"
