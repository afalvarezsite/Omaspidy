-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Sincronizar portapapeles de Wayland (asegura el uso de wl-clipboard en Hyprland)
opt.clipboard = "unnamedplus"

-- Fuente de GUI sin ligaduras (si usas clientes de Neovim graficos)
opt.guifont = "Hack Nerd Font:h12"

-- Mejor legibilidad (contraste y busqueda)
opt.cursorline = true
opt.scrolloff = 8

-- Rendimiento y agilidad
opt.updatetime = 200
