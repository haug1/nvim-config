return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(
          opts.ensure_installed,
          { "markdown", "markdown_inline" }
        )
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "marksman" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "markdownlint" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   opts = {
  --     linters_by_ft = {
  --       markdown = { "markdownlint" },
  --     },
  --   },
  -- },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    opts = {
      markdown = {
        bullets = {},
      },
      norg = {
        bullets = {},
      },
      rmd = {
        bullets = {},
      },
      org = {
        bullets = {},
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },
}
