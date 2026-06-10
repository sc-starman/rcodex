#!/usr/bin/env bash

set -e

mkdir -p "$HOME/bin"

curl -fsSL \
https://raw.githubusercontent.com/<username>/rcodex/main/rcodex \
-o "$HOME/bin/rcodex"

chmod +x "$HOME/bin/rcodex"

if ! grep -q 'HOME/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo
echo "rcodex installed."
echo
echo "Restart your shell or run:"
echo
echo "source ~/.bashrc"
