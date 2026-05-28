#!/usr/bin/env bash
# bg-remove.sh — provision the rembg-based background remover end-to-end.
#
# Idempotent. Re-run any time to refresh the local clone, reinstall the CLI,
# top up the model cache, and rewrite the wrapper script.
#
#   1. Ensure `uv` is installed.
#   2. Clone (or update) the rembg source into ~/Development/apps/bg-remove/rembg
#      as a reference copy. The install itself uses PyPI, not this clone —
#      the clone is so you can read or hack on the source locally.
#   3. Install `rembg[cpu,cli]` as a uv tool so the binary is on PATH globally.
#   4. Pre-warm the model cache in ~/.u2net/ for the eight essentials models.
#   5. Write the interactive wrapper to ~/.local/bin/app-bg.

set -euo pipefail

APP_DIR="$HOME/Development/apps/bg-remove"
REPO_DIR="$APP_DIR/rembg"
REPO_URL="https://github.com/danielgatis/rembg.git"
WRAPPER="$HOME/.local/bin/app-bg"
MODELS=(
  u2net
  u2netp
  u2net_human_seg
  u2net_cloth_seg
  silueta
  isnet-general-use
  isnet-anime
  birefnet-general-lite
)

info() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }

# --- 1. uv -------------------------------------------------------------------
if ! command -v uv >/dev/null 2>&1; then
  info "installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- 2. workspace + reference clone -----------------------------------------
info "ensuring $REPO_DIR"
mkdir -p "$APP_DIR"
if [ ! -d "$REPO_DIR/.git" ]; then
  git clone --depth 1 "$REPO_URL" "$REPO_DIR"
else
  git -C "$REPO_DIR" pull --ff-only || true
fi

# --- 3. install rembg CLI globally ------------------------------------------
info "installing rembg as a uv tool"
uv tool install --force "rembg[cpu,cli]"

# --- 4. pre-warm models ------------------------------------------------------
info "pre-warming ${#MODELS[@]} models into ~/.u2net/ (skips ones already cached)"
MODELS_CSV="$(IFS=,; echo "${MODELS[*]}")" \
uv run --quiet --no-project --with "rembg[cpu]" python -c '
import os
from rembg import new_session
for m in os.environ["MODELS_CSV"].split(","):
    print(f">>> {m}")
    new_session(m)
'

# --- 5. wrapper script -------------------------------------------------------
info "writing $WRAPPER"
mkdir -p "$(dirname "$WRAPPER")"
cat > "$WRAPPER" <<'BASH'
#!/usr/bin/env bash
# app-bg — interactive background remover (wraps rembg)
# Pick an image from the current directory, pick a model, write <name>.nobg.png alongside it.
set -euo pipefail

if ! command -v rembg >/dev/null 2>&1; then
  echo "error: 'rembg' not on PATH. install with: uv tool install 'rembg[cpu,cli]'" >&2
  exit 1
fi

shopt -s nullglob nocaseglob
files=( *.png *.jpg *.jpeg *.webp *.bmp *.gif *.tif *.tiff )
shopt -u nocaseglob

if (( ${#files[@]} == 0 )); then
  echo "no image files in $(pwd)" >&2
  exit 1
fi

echo "Images in $(pwd):"
for i in "${!files[@]}"; do
  printf "  [%2d] %s\n" "$((i+1))" "${files[i]}"
done
echo
read -r -p "Pick file # (1-${#files[@]}): " fchoice
if ! [[ "$fchoice" =~ ^[0-9]+$ ]] || (( fchoice < 1 || fchoice > ${#files[@]} )); then
  echo "invalid selection" >&2; exit 1
fi
input="${files[fchoice-1]}"

models=(
  "u2net|General-purpose default — solid all-rounder for most photos."
  "u2netp|Tiny (4 MB) version of u2net — fastest, lowest quality, useful for quick previews."
  "u2net_human_seg|Tuned specifically for human subjects (portraits, full body)."
  "u2net_cloth_seg|Segments clothing only (upper / lower / full garment) — for fashion images."
  "silueta|Same architecture as u2net but compressed to 42 MB — near-identical quality, much faster to load."
  "isnet-general-use|Newer general-purpose model — usually sharper edges than u2net."
  "isnet-anime|Tuned for anime / illustrated art rather than photographs."
  "birefnet-general-lite|Lightweight BiRefNet (213 MB) — modern architecture, strong general quality at moderate cost."
)

echo
echo "Models:"
for i in "${!models[@]}"; do
  name="${models[i]%%|*}"
  desc="${models[i]#*|}"
  printf "  [%2d] %-22s %s\n" "$((i+1))" "$name" "$desc"
done
echo
read -r -p "Pick model # (1-${#models[@]}): " mchoice
if ! [[ "$mchoice" =~ ^[0-9]+$ ]] || (( mchoice < 1 || mchoice > ${#models[@]} )); then
  echo "invalid selection" >&2; exit 1
fi
model="${models[mchoice-1]%%|*}"

stem="${input%.*}"
output="${stem}.nobg.png"

echo
echo "input:  $input"
echo "model:  $model"
echo "output: $output"
echo

rembg i -m "$model" "$input" "$output"

echo "done → $output"
BASH
chmod +x "$WRAPPER"

info "done."
echo
echo "  source:   $REPO_DIR"
echo "  models:   ~/.u2net/"
echo "  command:  app-bg  (run from any folder containing images)"
