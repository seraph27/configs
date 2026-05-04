-- LSP Configuration
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        -- C++ Language Server (clangd)
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=0",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = false,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          -- Disable completions but keep diagnostics
          on_attach = function(client, _)
            client.server_capabilities.completionProvider = nil
          end,
        },
        -- Python Language Server (pyright) — extended by lazyvim python extra
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        -- Lua Language Server
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        -- Rust is handled by lazyvim.plugins.extras.lang.rust (rustaceanvim)

        -- Web dev LSPs (TS/Svelte/Tailwind handled by LazyVim extras)
        cssls = {},
        html = {},
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "svelte" },
        },

        -- Swift/iOS
        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "objective-c", "objective-cpp" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("Package.swift", ".xcodeproj", ".xcworkspace", "buildServer.json")(fname)
              or util.find_git_ancestor(fname)
          end,
        },
      },
    },
  },
}

