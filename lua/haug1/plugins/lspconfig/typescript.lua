return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ts_ls", "html", "cssls", "eslint" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "prettier", "eslint" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(
        opts.ensure_installed,
        { "javascript", "typescript", "scss" }
      )
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["svelte"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["less"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        "neotest-vitest",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    opts = {},
  },
}
