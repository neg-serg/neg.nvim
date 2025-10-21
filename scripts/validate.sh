#!/usr/bin/env bash
set -euo pipefail

# Run validator using Neovim headless with this repo on runtimepath
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec nvim --headless -u NONE \
  +"set rtp^=${ROOT_DIR}" \
  +"lua require('neg.validate').exit()"

