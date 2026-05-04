-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure Cargo/Rust is in PATH for rust-analyzer
vim.env.PATH = vim.env.HOME .. "/.cargo/bin:" .. vim.env.PATH

vim.g.have_nerd_font = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.relativenumber = true

-- Default tab settings (4 spaces for CP / Python / Rust / C++)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 2-space tabs for web dev files
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "svelte", "astro", "html", "css", "scss", "json", "jsonc", "yaml",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

-- Disable list chars (dashes showing spaces)
vim.opt.list = false

-- Scroll offset
vim.opt.scrolloff = 10

-- Mouse
vim.opt.mouse = "a"

-- Clipboard
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Disable autoformatting globally
vim.g.autoformat = false

-- Faster key repeat (reduce delay for arrow keys)
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10

-- Disable inlay hints globally
vim.g.lazyvim_inlay_hints = false
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})
