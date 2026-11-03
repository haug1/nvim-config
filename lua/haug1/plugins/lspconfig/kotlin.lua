return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "kotlin_lsp" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "kotlin-debug-adapter",
        { "ktrs", version = "v0.5.3" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.kotlin_lsp = {}
      opts.servers.kotlin_language_server = { enabled = false }
      opts.servers.ktrs = {
        cmd = {
          vim.fn.stdpath("data") .. "/mason/bin/ktrs",
          "lsp",
        },
        filetypes = { "kotlin" },
        root_markers = {
          "settings.gradle.kts",
          "settings.gradle",
          "build.gradle.kts",
          "build.gradle",
          "pom.xml",
          ".git",
        },
        init_options = {
          format = { tool = "ktlint" },
          ktlint = { version = "1.8", enable = true },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Select ktrs explicitly; kotlin_lsp also advertises formatting.
      opts.formatters_by_ft.kotlin = { lsp_format = "prefer", name = "ktrs" }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "Mgenuit/neotest-kotlin",
    },
    opts = {
      adapters = {
        ["neotest-kotlin"] = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")

      local mason_adapter = vim.fn.stdpath("data")
        .. "/mason/bin/kotlin-debug-adapter"
      local adapter_cmd = vim.fn.executable(mason_adapter) == 1
          and mason_adapter
        or "kotlin-debug-adapter"

      dap.adapters.kotlin = {
        type = "executable",
        command = adapter_cmd,
        args = {},
      }

      dap.configurations.kotlin = {
        {
          type = "kotlin",
          request = "launch",
          name = "Launch Kotlin (prompt for main class)",
          projectRoot = "${workspaceFolder}",
          mainClass = function()
            return vim.fn.input("Main class: ")
          end,
        },
      }
    end,
  },
}
