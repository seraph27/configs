-- Dashboard for competitive programming - override LazyVim's snacks dashboard
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
      ███████╗███████╗██████╗  ██████╗ ██████╗ ██╗  ██╗
      ██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗██║  ██║
      ███████╗█████╗  ██████╔╝███████║██████╔╝███████║
      ╚════██║██╔══╝  ██╔══██╗██╔══██║██╔═══╝ ██╔══██║
      ███████║███████╗██║  ██║██║  ██║██║     ██║  ██║
      ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝
]],
          keys = {
            { icon = "✺ ", key = "f", desc = "Fetch Problem", action = ":CompetiTest receive problem" },
            { icon = " ", key = "t", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "✺ ", key = "c", desc = "Fetch Contest", action = ":CompetiTest receive contest" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Restore Session", action = ":lua require('persistence').load()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
