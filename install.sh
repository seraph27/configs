#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Claude Code. The scripts are symlinked because Claude Code never writes them.
# settings.json is copied instead: /config writes it atomically, which would
# replace a symlink with a regular file and silently break the link.
mkdir -p "$HOME/.claude/hooks"
ln -sf "$DOTFILES/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
ln -sf "$DOTFILES/claude/hooks/guard-bash-global.sh" "$HOME/.claude/hooks/guard-bash-global.sh"
ln -sf "$DOTFILES/claude/hooks/label-session.sh" "$HOME/.claude/hooks/label-session.sh"
[ -f "$HOME/.claude/settings.json" ] && cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.bak"
cp "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"

echo "done"
