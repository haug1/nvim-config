# AGENTS Notes

Quick orientation for this Neovim config.

- Entrypoint: `init.lua` -> `lua/haug1/init.lua`.
- Plugin manager: `lazy.nvim` (see `lua/haug1/core/lazy.lua`).
- Plugin specs:
  - General: `lua/haug1/plugins/*.lua`
  - Language/LSP: `lua/haug1/plugins/lspconfig/*.lua`
- Language modules in `plugins/lspconfig/` are auto-imported via
  `require("lazy").setup({ spec = { { import = "haug1.plugins" }, { import = "haug1.plugins.lspconfig" } } })`.

LSP conventions used here:

- Add LSP server install in `mason-org/mason-lspconfig.nvim` `opts.ensure_installed`.
- Add server config under `neovim/nvim-lspconfig` -> `opts.servers`.
- Add parser in `nvim-treesitter` `opts.ensure_installed` when relevant.
- Add formatting/linting in `conform.nvim` / `nvim-lint` only when needed.

Useful checks:

- `rg --files lua/haug1/plugins/lspconfig`
- `rg -n "ensure_installed|servers" lua/haug1/plugins/lspconfig`
- `nvim --headless "+Lazy! sync" +qa` (optional full plugin sync)
