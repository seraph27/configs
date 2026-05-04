-- Ensure Mason installs all LSP servers and tools
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "css-lsp",
        "html-lsp",
        "emmet-ls",
        "json-lsp",
        "yaml-language-server",
        "lua-language-server",
        "pyright",
        "clangd",
        -- TS/Svelte/Astro/Tailwind handled by LazyVim extras
      },
    },
  },
}
