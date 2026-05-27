return {
  -- Lualine (Status bar)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "tokyonight"
    end,
  },
  
  -- Snacks Dashboard personalizado
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
   \ \  / /
    \ \/ /
_-\/    \/-_
 -/      \-
 //      \\
//        \\

Spider-Man IDE
]],
        },
      },
    },
  },
}
