#!/bin/sh
{
  echo "--- date ---"
  date
  echo "--- PATH ---"
  echo "$PATH"
  echo "--- SHELL ---"
  echo "$SHELL"
  echo "--- which nvim ---"
  which nvim
  command -v nvim
  echo "--- nvim --version ---"
  /opt/homebrew/bin/nvim --version 2>&1 | head -5
  echo "--- nvim exit code (no tty test) ---"
  /opt/homebrew/bin/nvim --headless +q 2>&1
  echo "exit=$?"
  echo "--- launching nvim interactively ---"
} > /tmp/nvim-popup.log 2>&1
exec /opt/homebrew/bin/nvim 2>>/tmp/nvim-popup.log
