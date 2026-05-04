-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- CompetiTest keybindings
map("n", "<leader>r", ":CompetiTest run<CR>", { desc = "CompetiTest Run" })
map("n", "<leader>a", ":CompetiTest add_testcase<CR>", { desc = "CompetiTest Add testcase" })
map("n", "<leader>e", ":CompetiTest edit_testcase<CR>", { desc = "CompetiTest Edit testcase" })

-- Neo-tree file explorer (just \ to toggle)
map("n", "\\", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Select all with Ctrl+A
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("v", "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Splits: create
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split horizontal" })

-- Splits: resize with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Splits: close
map("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close split" })

-- Barbar buffer navigation
local opts = { noremap = true, silent = true }
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous buffer" }))
map("n", "<A-.>", "<Cmd>BufferNext<CR>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", vim.tbl_extend("force", opts, { desc = "Move buffer left" }))
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", vim.tbl_extend("force", opts, { desc = "Move buffer right" }))
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 1" }))
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 2" }))
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 3" }))
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 4" }))
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 5" }))
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 6" }))
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 7" }))
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 8" }))
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", vim.tbl_extend("force", opts, { desc = "Go to buffer 9" }))
map("n", "<A-0>", "<Cmd>BufferLast<CR>", vim.tbl_extend("force", opts, { desc = "Go to last buffer" }))
map("n", "<A-p>", "<Cmd>BufferPin<CR>", vim.tbl_extend("force", opts, { desc = "Pin buffer" }))
map("n", "<A-c>", "<Cmd>BufferClose<CR>", vim.tbl_extend("force", opts, { desc = "Close buffer" }))
