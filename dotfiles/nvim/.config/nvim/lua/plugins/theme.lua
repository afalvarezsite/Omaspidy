return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false, -- Fondo opaco para maxima legibilidad
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark", -- Fondo oscuro en paneles laterales para separar del codigo
        floats = "dark",
      },
      on_colors = function(colors)
        -- Inyectamos la paleta rojinegra Spider-Man
        colors.bg = "#0c0d12"          -- Negro profundo, muy alto contraste
        colors.bg_dark = "#0a0a0e"
        colors.bg_float = "#16171f"
        colors.bg_highlight = "#1f202a"
        colors.bg_sidebar = "#0a0a0e"
        colors.bg_search = "#e60026"   -- Fondo rojo vibrante en busquedas
        colors.fg_search = "#ffffff"

        -- Acentos y lineas rojas
        colors.border = "#ff3b5c"
        colors.border_highlight = "#e60026"
        
        -- Errores y warnings con colores puros
        colors.error = "#ff1e43"
        colors.warning = "#ff8f40"
      end,
      on_highlights = function(hl, c)
        -- Customizacion de la linea actual y el cursor
        hl.CursorLine = { bg = c.bg_highlight }
        hl.Visual = { bg = "#4a000e" } -- Seleccion en rojo muy oscuro
        hl.LineNr = { fg = "#474b5c" }
        hl.CursorLineNr = { fg = "#e60026", bold = true } -- Numero de linea actual en rojo fuerte
      end,
    },
  },
}
