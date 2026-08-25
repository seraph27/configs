vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#6b7280" })
  end,
})

-- Swap multitest → atcoder template when CompetiTest receives an AtCoder problem
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.cpp",
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 6, false)
    if #lines < 6 or lines[6] ~= "// multitest" then return end
    if lines[3]:find("atcoder%.jp") then
      local tpl = vim.fn.expand("~/Documents/GitHub/competitve-programming/templates/atcoder.cpp")
      local tpl_lines = vim.fn.readfile(tpl)
      for i = 1, 5 do tpl_lines[i] = lines[i] end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, tpl_lines)
      vim.cmd("silent! write")
    end
  end,
})

-- Competitive programming template auto-insertion
local templates = {
  { "*/projecteuler/*.py", "py_template.py" },
  { "*/atcoder/*.py", "py_template.py" },
  -- cpp
  { "*/codeforces/*.cpp", "multitest.cpp" },
  { "*/atcoder/*.cpp", "atcoder.cpp" },
  { "*/atcoder/*.ts", "atcoder.ts" },
  { "*/usaco/*.cpp", "singletest.cpp" },
  { "*/cses/*.cpp", "singletest.cpp" },
  { "*/leetcode/*.cpp", "leetcode_local.cpp" },
  { "*/zj/*.cpp", "singletest.cpp" },
  { "*/qoj/*.cpp", "singletest.cpp" },
  { "*/luogu/*.cpp", "singletest.cpp" },
  { "*/other/*.cpp", "singletest.cpp" },
  { "*/qiita/*.cpp", "singletest.cpp" },
  { "*/tioj/*.cpp", "singletest.cpp" },
  { "*/toj/*.cpp", "singletest.cpp" },
  { "*/uva/*.cpp", "singletest.cpp" },
  -- rust
  { "*/codeforces/*.rs", "rust_template.rs" },
  { "*/atcoder/*.rs", "rust_template.rs" },
  { "*/usaco/*.rs", "rust_template.rs" },
  { "*/cses/*.rs", "rust_template.rs" },
  { "*/zj/*.rs", "rust_template.rs" },
  { "*/qoj/*.rs", "rust_template.rs" },
  { "*/luogu/*.rs", "rust_template.rs" },
  { "*/other/*.rs", "rust_template.rs" },
  { "*/qiita/*.rs", "rust_template.rs" },
  { "*/tioj/*.rs", "rust_template.rs" },
  { "*/toj/*.rs", "rust_template.rs" },
  { "*/uva/*.rs", "rust_template.rs" },
}

local group = vim.api.nvim_create_augroup("cp-templates", { clear = true })
local base = "~/Documents/GitHub/competitve-programming/templates/"

for _, t in ipairs(templates) do
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = t[1],
    command = "0r " .. base .. t[2],
  })
end

-- Auto-close empty buffers after CompetiTest receives problems
vim.api.nvim_create_autocmd("User", {
  pattern = "CompetiTestReceive",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == "" then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if #lines == 1 and lines[1] == "" then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end,
})
