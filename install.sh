#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "done"
