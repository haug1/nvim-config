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

Format-on-save uses the configured Conform formatters, including explicitly
selected LSP formatters. Use `<leader>fb` for manual formatting with LSP fallback.
Formatter errors appear as notifications.

## Kotlin

Kotlin uses `ktrs lsp` alongside `kotlin_lsp`: ktrs provides ktlint 1.8-compatible
formatting and lint diagnostics, while Kotlin LSP provides language intelligence.
Mason installs [ktrs](https://github.com/Hexay/ktrs/releases/tag/v0.5.3) at the
pinned version 0.5.3 using the local registry in `lua/haug1/mason-registry/`.
The package definition supports Linux and macOS on x86-64 and ARM64; Linux uses
the static musl build, including on NixOS. No manual installation or Nix change
is needed. The LSP uses Mason's binary directly, avoiding an unrelated version
on `PATH`.

On a fresh machine, let the automatic tool installation finish, then reopen
Neovim. `:MasonToolsInstall` can also trigger installation; `:Mason` shows its
status. To upgrade ktrs, update the version in both the local package definition
and `kotlin.lua`, then run `:MasonToolsInstall`.

Conform selects only ktrs for Kotlin formatting, including `<leader>fb` and
format-on-save. `<leader>uf` still toggles automatic formatting. Diagnostics
update through LSP, so no ktlint CLI, JVM worker, or prewarm hook is needed.
Project `.editorconfig` files control style; without them, ktrs uses its standard
defaults rather than the old personal two-space fallback. Use `:LspInfo` to check
attachment and `<leader>lsr` to restart language servers.

## Terminals

`<C-t>` toggles the selected terminal, `<C-n>` creates a terminal, and
`<C-.>` / `<C-,>` cycle through running terminals. These mappings close and
reopen terminals through toggleterm's API so the terminal job stays attached to
its terminal buffer. `<C-\>` toggles a reusable lazygit terminal.

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
