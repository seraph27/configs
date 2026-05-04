return {
  {
    "Exafunction/windsurf.nvim",
    cmd = "Codeium",
    event = "InsertEnter",
    keys = {
      { "<leader>cp", "<cmd>Codeium Toggle<cr>", desc = "Toggle Codeium" },
    },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = false,
          key_bindings = {
            accept = "<Tab>",
            accept_word = "<C-Right>",
            accept_line = "<C-End>",
            next = "<M-]>",
            prev = "<M-[>",
            clear = "<C-]>",
          },
        },
      })
    end,
  },
}
