-- DECIDED (colors FINAL, 2026-10-10; 25-colors §11): Neovim = kanagawa-wave with its own background
-- (no `transparent`; the Ghostty hard-hybrid frame #1d2021 vs #1f1f28 is a ~1.00:1 seam).
-- compile = true (D-22/D-23). All other kanagawa options are upstream defaults.
-- With compile = true kanagawa caches highlights (string.dump bytecode) in ~/.local/state/nvim/kanagawa/
-- and only rebuilds when no cache exists.
-- DECIDED (Q-3): recompile automatically after :Lazy update / :Lazy sync (lazy.nvim fires User LazyUpdate /
-- LazySync when they finish). Registered in `init` (runs at startup) rather than config/autocmds.lua
-- (loaded on VeryLazy), so `nvim --headless "+Lazy! sync" +qa` also triggers it.
-- Still manual: after editing the opts below, or after a Neovim upgrade without a Lazy update/sync
-- (LuaJIT bytecode may change), run :KanagawaCompile.
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("kanagawa_recompile", { clear = true }),
        pattern = { "LazyUpdate", "LazySync" },
        desc = "Recompile the kanagawa highlight cache after plugin updates",
        callback = function()
          local ok, err = pcall(vim.cmd, "KanagawaCompile")
          if not ok then
            vim.notify("KanagawaCompile failed: " .. tostring(err), vim.log.levels.WARN)
          end
        end,
      })
    end,
    opts = {
      compile = true,
      theme = "wave",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa-wave" },
  },
}
