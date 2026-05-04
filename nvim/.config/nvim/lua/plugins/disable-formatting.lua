-- Completely disable auto-formatting for competitive programming
return {
  -- Disable conform.nvim completely
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  -- Disable LSP formatting
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = opts.servers or {}
      
      -- Disable formatting for all servers
      for server_name, server_opts in pairs(servers) do
        if not server_opts then
          servers[server_name] = {}
        end
        local original_on_attach = servers[server_name].on_attach
        servers[server_name].on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          if original_on_attach then
            original_on_attach(client, bufnr)
          end
        end
      end
      
      opts.servers = servers
      return opts
    end,
  },
  -- Disable LazyVim's format on save
  {
    "LazyVim/LazyVim",
    opts = {
      autoformat = false,
    },
  },
}

