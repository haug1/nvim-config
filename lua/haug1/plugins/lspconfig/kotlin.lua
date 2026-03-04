return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "kotlin_language_server" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ktlint", "kotlin-debug-adapter" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      local java21_candidates = vim.fn.glob(
        vim.fn.expand("$HOME/.sdkman/candidates/java/21*"),
        false,
        true
      )
      local java21_home = java21_candidates[1]

      local server_opts = {}
      if java21_home and java21_home ~= "" and vim.fn.isdirectory(java21_home) == 1 then
        server_opts.cmd_env = {
          JAVA_HOME = java21_home,
          PATH = java21_home .. "/bin:" .. vim.env.PATH,
        }
      end

      opts.servers.kotlin_language_server = vim.tbl_deep_extend(
        "force",
        opts.servers.kotlin_language_server or {},
        server_opts
      )
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = { "ktlint" },
      },
    },
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
      local adapter_cmd = vim.fn.executable(mason_adapter) == 1 and mason_adapter
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
