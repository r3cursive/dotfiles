-- LazyVim/starter @ 803bc181d7c0d6d5eeba9274d9be49b287294d99 (2024-12-11), for LazyVim v16.0.1.
-- Track D v3 (docs/plans/40-editors.md). Changes from the starter are marked "D-xx:" (DECIDED, editors baseline
-- confirmed 2026-10-10).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Language extras (D-22) are listed in ~/.config/nvim/lazyvim.json (LazyVim's standard mechanism).
    -- DECIDED (Q-1): lazyvim.json is managed by chezmoi. LazyVim rewrites it (first launch "news", :LazyExtras),
    -- so after such changes run `chezmoi re-add ~/.config/nvim/lazyvim.json`.
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- D-22: lazy checker off (battery). Update deliberately with :Lazy update, then
  -- `chezmoi re-add ~/.config/nvim/lazy-lock.json`.
  checker = {
    enabled = false,
    notify = false,
  },
  -- change_detection: stock (enabled + notify on config edits) — DECIDED (Q-2).
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
