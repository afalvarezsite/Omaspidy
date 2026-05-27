return {
  -- Integracion simulada/preparada para Antigravity AI
  {
    "antigravity/antigravity.nvim",
    cmd = "Antigravity",
    keys = {
      { "<leader>aa", "<cmd>Antigravity toggle<cr>", desc = "Toggle AI Assistant" },
      { "<leader>ac", "<cmd>Antigravity chat<cr>", desc = "AI Chat" },
      { "<leader>ae", "<cmd>Antigravity explain<cr>", desc = "AI Explain Code", mode = { "n", "v" } },
    },
    opts = {
      theme = "spider",
      window = {
        border = "rounded",
        winblend = 0, -- Fondo opaco para leer el chat AI correctamente
      },
    },
  },
}
