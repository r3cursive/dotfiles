-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- D-22: Python = basedpyright + ruff (lang.python extra reads these).
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- D-22: animations off (battery). Disables all Snacks animations incl. smooth scroll.
vim.g.snacks_animate = false

-- DECIDED (2026-10-10): format on save = LazyVim stock (vim.g.autoformat = true). Toggle per session: <leader>uf / <leader>uF.
