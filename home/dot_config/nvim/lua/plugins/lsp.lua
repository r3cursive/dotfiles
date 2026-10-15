-- Language servers come from the LazyVim lang extras (lazyvim.json). Only decided overrides live here.
-- Checked against LazyVim v16.0.1 (plugins/lsp/init.lua: a server with `mason = false` is set up from PATH
-- and excluded from mason-lspconfig's automatic install).
--
-- D-22/D-24: rust-analyzer comes from rustup. The lang.rust extra (rustaceanvim) never installs it via mason;
-- it runs `rust-analyzer` from PATH (~/.cargo/bin). Check command: stock `cargo check` — DECIDED (Q-6).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- DECIDED (Q-4/Q-40): system binaries on PATH, not mason.
        --   ruff  = Fedora `ruff` (/usr/bin/ruff)
        --   gopls = `go install golang.org/x/tools/gopls@<pinned>` → ~/go/bin (on PATH via ~/.zshenv and the
        --           Plasma env file). mason still installs goimports/gofumpt/golangci-lint for lang.go.
        ruff = { mason = false },
        gopls = { mason = false },
        -- DECIDED (Q-5): basedpyright typeCheckingMode "standard" in every editor (basedpyright's own default is
        -- "recommended"). A project's pyproject.toml / pyrightconfig.json still overrides this.
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
          },
        },
      },
    },
  },
}
