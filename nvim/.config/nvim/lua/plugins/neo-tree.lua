-- Enhanced neo-tree for project navigation
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        -- Follow the file you're editing
        follow_current_file = { enabled = true },
        -- Use system trash instead of permanent delete
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            "node_modules",
            ".git",
            "__pycache__",
            ".next",
            ".svelte-kit",
            ".astro",
            ".DS_Store",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        group_empty_dirs = true,
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none", -- Don't conflict with leader
          ["h"] = "close_node",
          ["l"] = "open",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
          },
        },
      },
      -- Nest related files together (index.ts, index.test.ts, index.module.css)
      nesting_rules = {
        ["ts"] = { "test.ts", "spec.ts", "d.ts", "module.css", "module.scss" },
        ["tsx"] = { "test.tsx", "spec.tsx", "module.css", "module.scss" },
        ["js"] = { "test.js", "spec.js", "module.css", "module.scss" },
        ["jsx"] = { "test.jsx", "spec.jsx" },
        ["package.json"] = { "package-lock.json", "bun.lock", "yarn.lock", "pnpm-lock.yaml", ".npmrc" },
        ["tsconfig.json"] = { "tsconfig.*.json" },
        [".eslintrc.js"] = { ".eslintignore" },
        ["tailwind.config.js"] = { "tailwind.config.ts", "postcss.config.*" },
      },
    },
  },
}
