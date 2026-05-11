-- Snacks picker defaults — show hidden + gitignored files everywhere.
-- Applies to <leader>ff, <leader>sf, and dashboard's "Find File" since they
-- all funnel through Snacks.picker.files / Snacks.dashboard.pick('files').
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,  -- show dotfiles
            ignored = true, -- show gitignored files (specs/, etc.)
          },
          grep = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
