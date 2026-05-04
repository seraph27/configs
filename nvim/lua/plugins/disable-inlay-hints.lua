-- Disable inlay hints and configure completion
return {
  {
    "saghen/blink.cmp",
    opts = {
      signature = { enabled = false },
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "fallback" },  -- Enter = newline, NOT autocomplete
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}

