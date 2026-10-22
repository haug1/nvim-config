return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "terraform",
          "hcl",
        })
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "terraformls" })
    end,
  },
  {
    -- NOTE: installs a patched terraform-ls with much better performance
    "haug1/terraform-ls",
    branch = "fix/codelens-reference-count-perf",
    lazy = true,
    build = "go build -o bin/terraform-ls .",
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local patched = vim.fn.stdpath("data")
        .. "/lazy/terraform-ls/bin/terraform-ls"

      local terraformls
      if vim.fn.executable(patched) == 1 then
        terraformls = { cmd = { patched, "serve" } }
      else
        terraformls = {
          capabilities = {
            experimental = { showReferencesCommandId = false },
          },
        }
      end

      opts.servers = opts.servers or {}
      opts.servers.terraformls = terraformls
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
  },
}
