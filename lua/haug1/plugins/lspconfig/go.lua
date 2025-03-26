vim.filetype.add({
  extension = { templ = "templ" },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "goimports",
        "gofumpt",
        "gomodifytags", -- TODO: Expose code action with null-ls
        "impl", -- TODO: Expose code action with null-ls
        "delve",
        "templ",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          recursive_run = true,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          cmd_env = { GOFUMPT_SPLIT_LONG_LINES = "on" },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                -- TODO: no longer supported(?) fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },
  -- TODO: debugging
}
