return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(
        opts.ensure_installed,
        { "vtsls", "html", "cssls", "eslint" }
      )
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "prettier" })
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
        -- Single TypeScript server for all JS/TS. Vue support is layered
        -- on in vue.lua (it injects @vue/typescript-plugin and the `vue`
        -- filetype). Svelte is self-contained, so it is intentionally
        -- absent here.
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {},
              },
            },
          },
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
          },
        },
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
