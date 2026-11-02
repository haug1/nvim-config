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
        "ktfmt",
        "ktlint",
        "kotlin-debug-adapter",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.kotlin_lsp = {}
      opts.servers.kotlin_language_server = { enabled = false }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local ktlint = require("haug1.config.ktlint")
      local cmd, jvm_args = ktlint.command("format")

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.kotlin = { "ktlint" }
      opts.formatters = opts.formatters or {}
      opts.formatters.ktlint = {
        command = cmd,
        -- Give ktlint the file path so it finds the project's .editorconfig (also path-scoped sections)
        args = vim.list_extend(vim.deepcopy(jvm_args), {
          "--format",
          "--stdin",
          "--log-level=none",
          "--editorconfig=" .. ktlint.default_editorconfig,
          "--stdin-path",
          "$FILENAME",
        }),
        -- 1 = unfixable lint remains, but the formatted output is still valid
        exit_codes = { 0, 1 },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        kotlin = { "ktlint" },
      },
    },
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
