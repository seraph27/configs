# nvim

Personal Neovim config built on [LazyVim](https://github.com/LazyVim/LazyVim), tuned for competitive programming (C++/Rust) and general use.

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
brew install stow   # or: apt install stow
stow --dir=~/configs --target=~ nvim
stow --dir=~/configs --target=~ tmux
```

Open Neovim. Lazy will auto-install all plugins.

**For competitive programming**, install [Competitive Companion](https://github.com/jmerle/competitive-companion) browser extension and set the port to `27121`. Then use `:CompetiTest receive problem` or hit `f` on the dashboard.

**AI completions** require a free [Windsurf account](https://codeium.com). Run `:Codeium Auth` after setup.
