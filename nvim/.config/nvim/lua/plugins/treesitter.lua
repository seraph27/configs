-- Ensure treesitter grammars are installed for all languages we use
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Web
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "scss",
        "svelte",
        -- Config
        "json",
        "jsonc",
        "yaml",
        "toml",
        -- CP / Systems
        "c",
        "cpp",
        "rust",
        "python",
        -- Scripting
        "lua",
        "bash",
        -- iOS
        "swift",
        -- Misc
        "markdown",
        "markdown_inline",
        "regex",
        "dockerfile",
        "gitignore",
      },
    },
  },
}
