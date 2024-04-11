local function is_vue_project()
  local current_path = vim.fn.expand("%:p:h")
  local util = require("lspconfig.util")
  local project_root = util.find_node_modules_ancestor(current_path)
  local vue_path = util.path.join(project_root, "node_modules", "vue")
  return vim.fn.isdirectory(vue_path) == 1
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vue" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "volar" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        vue = { "eslint_d" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["vue"] = { "prettier" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if is_vue_project() then -- if not vue project, skip config
        opts.servers = opts.servers or {}

        -- disable tsserver because volar runs in "takeover" mode,
        -- which means it handles all typescript stuff
        opts.servers.tsserver = { enabled = false }

        opts.servers.volar = {
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        }
      end
    end,
  },
}
