-- Rust support: customizes the LazyVim Rust extra (rustaceanvim)
return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = {
              allFeatures = true,
              buildScripts = { enable = true },
            },
            procMacro = { enable = true },
            inlayHints = { enable = false },
          },
        },
      },
    },
  },
}
