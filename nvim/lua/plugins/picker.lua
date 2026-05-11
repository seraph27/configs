-- Snacks picker defaults — show hidden + gitignored files everywhere.
-- Applies to <leader>ff, <leader>sf, and dashboard's "Find File" since they
-- all funnel through Snacks.picker.files / Snacks.dashboard.pick('files').
--
-- `exclude` keeps the heavy build/dep dirs out even though we disabled
-- gitignore filtering — these are never useful in a file picker.
local EXCLUDE = {
  "node_modules",
  ".git",
  ".next",
  "dist",
  "build",
  "target",     -- rust
  ".turbo",
  ".vercel",
  "__pycache__",
  ".venv",
  ".cache",
  ".DS_Store",
  "*.lock",     -- package-lock.json, Cargo.lock, etc.
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,  -- show dotfiles
            ignored = true, -- show gitignored files (specs/, etc.)
            exclude = EXCLUDE,
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = EXCLUDE,
          },
        },
      },
    },
  },
}
