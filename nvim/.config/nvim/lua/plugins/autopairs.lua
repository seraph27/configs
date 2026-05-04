-- nvim-autopairs: better auto-pairing (replaces mini.pairs)
return {
  -- Disable mini.pairs (LazyVim default) to avoid conflicts
  { "nvim-mini/mini.pairs", enabled = false },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- use treesitter to check for pairs
      fast_wrap = {}, -- enable fast wrap with Alt-e
    },
  },
}
