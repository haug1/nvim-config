# Neovim config

This config uses Neovim's native LSP API and requires Neovim 0.12.0 or newer.
Plugins are managed by `lazy.nvim`; `lazy-lock.json` records the plugin
revisions used for reproducible installs.

## NixOS

Provide language servers and formatters through Nix packages or the project's
dev shell. On NixOS, Mason is kept at the end of `PATH`, and this config does
not ask Mason to install `nil` or `alejandra`, since generic Linux Mason
binaries may not run there. Add `nil` and `alejandra` to the environment if you
want Nix diagnostics and format-on-save for Nix files.

Format-on-save runs configured Conform formatters only. Use `<leader>fb` for
manual formatting with LSP fallback. Formatter errors appear as notifications.

## Fresh install

Make sure `git`, `curl` or `wget`, `tar`, `unzip`, a C compiler, and the
`tree-sitter` CLI (0.26.1 or newer) are available. Install the CLI through the
system package manager rather than Mason. On NixOS, provide `tree-sitter` via
Nix. Mason installs the remaining language tools. Start Neovim and run `:Lazy`
to inspect plugin setup.

## Layout

- `init.lua` loads `lua/haug1/init.lua`.
- `lua/haug1/core/` contains editor options, keymaps, and autocommands.
- `lua/haug1/plugins/` contains general plugin specifications.
- `lua/haug1/plugins/lspconfig/` contains language servers, formatters,
  linters, tests, and debugging configuration.
- `lua/haug1/config/` contains custom plugin helpers.

Abandon All Hope, Ye Who Enter Here
