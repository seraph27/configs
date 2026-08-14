# configs

Personal Neovim config built on [LazyVim](https://github.com/LazyVim/LazyVim), tuned for competitive programming (C++/Rust) and general use, plus a Claude Code setup.

## Claude Code

`claude/` holds the settings, status line, and hooks. `install.sh` symlinks the scripts into `~/.claude` and copies `settings.json` (backing up any existing one to `settings.json.bak`).

The status line renders `branch │ model·effort │ context gauge │ 7d quota` in Catppuccin Mocha:

```
main │ opus-5·xhigh │ ███░░░░░░░ 34% 1M │ 7d 41%
```

The gauge turns yellow at 55% of the context window and red at 80%, and the size next to it shows whether the session got a 1M or 200k window. It falls back to 256-color, then to no color under `NO_COLOR`, and to ASCII glyphs outside a UTF-8 locale. Without `jq` it degrades to branch and model rather than failing.

Two hooks: `guard-bash-global.sh` blocks cross-project footguns on `PreToolUse` (pkill, printenv, reading `.env`, `git reset --hard`, `git clean -f`, plain `--force` pushes, recursive `rm` outside temp dirs), and `label-session.sh` auto-names each background agent from its first real prompt and gives it a deterministic color.

## Plugins

| Plugin | What it does |
|---|---|
| [competitest.nvim](https://github.com/xeluxee/competitest.nvim) | Fetch problems/contests from Competitive Companion, run test cases, auto-select template (AtCoder/CF/other) |
| [leetcode.nvim](https://github.com/kawre/leetcode.nvim) | Solve LeetCode problems inside Neovim |
| [windsurf.nvim](https://github.com/Exafunction/windsurf.nvim) | Free unlimited inline AI completions (disabled by default, `<leader>cp` to toggle) |
| [barbar.nvim](https://github.com/romgrk/barbar.nvim) | Tab bar for buffers |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless pane navigation between Neovim and tmux |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Inline git blame on current line |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history |
| [vim-obsession](https://github.com/tpope/vim-obsession) | Auto-save/restore sessions |
| [wakatime](https://github.com/wakatime/vim-wakatime) | Coding time tracking |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Custom snippets for competitive programming |

## Themes

Catppuccin Mocha is the default. All themes below are installed and hot-swappable without restarting Neovim.

bamboo, catppuccin, everforest, flexoki, gruvbox, kanagawa, matteblack, monokai-pro, nord, rose-pine, tokyonight

## Competitive Programming Setup

- Compiles with g++-15 (`-std=c++23`, ac-library included)
- Three templates: `multitest.cpp` (Codeforces), `atcoder.cpp` (AtCoder), `singletest.cpp` (others)
- Template auto-selected based on problem URL when fetched via Competitive Companion
- Test cases stored in `testcase/` folder per problem

## Setup

**Dependencies:** Neovim 0.10+, git, a [Nerd Font](https://www.nerdfonts.com/), tmux (optional)

```bash
git clone https://github.com/seraph27/configs ~/configs
cd ~/configs && ./install.sh
```

Open Neovim. Lazy will auto-install all plugins.

**For competitive programming**, install [Competitive Companion](https://github.com/jmerle/competitive-companion) browser extension and set the port to `27121`. Then use `:CompetiTest receive problem` or hit `f` on the dashboard.

**AI completions** require a free [Windsurf account](https://codeium.com). Run `:Codeium Auth` after setup.
