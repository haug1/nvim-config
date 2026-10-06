return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- NixOS packages should provide `nil`; Mason's generic Linux binary may
      -- not run without the dynamic loader it expects.
      if not require("haug1.core.util").is_nixos() then
        vim.list_extend(opts.ensure_installed, { "nil_ls" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      -- Prefer the formatter from the active Nix environment on NixOS.
      if not require("haug1.core.util").is_nixos() then
        vim.list_extend(opts.ensure_installed, { "alejandra" })
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- Don't start a missing NixOS executable; that otherwise emits a client
      -- startup error every time a Nix buffer opens.
      local util = require("haug1.core.util")
      local is_nixos = util.is_nixos()
      opts.servers.nil_ls = {
        enabled = not is_nixos or util.executable_outside_mason("nil"),
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local util = require("haug1.core.util")
      local is_nixos = util.is_nixos()
      if not is_nixos or util.executable_outside_mason("alejandra") then
        opts.formatters_by_ft.nix = { "alejandra" }
      end
    end,
  },
}
