-- Custom snippets for competitive programming
return {
  -- LuaSnip with custom snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")

      -- Load friendly-snippets first
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load custom competitive programming snippets
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
          vim.fn.expand("~") .. "/Documents/GitHub/competitve-programming/lib/snippets",
        },
      })

      -- LuaSnip configuration
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
    end,
  },
  -- Configure blink.cmp to use LuaSnip
  {
    "saghen/blink.cmp",
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}

