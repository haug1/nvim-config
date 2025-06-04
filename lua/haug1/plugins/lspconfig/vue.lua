local function is_vue_project()
  local current_path = vim.fn.expand("%:p:h")
  local util = require("lspconfig.util")
  local project_root = vim.fs.dirname(
    vim.fs.find("node_modules", { path = current_path, upward = true })[1]
  )
  if not project_root then
    return false
  end
  local vue_path = util.path.join(project_root, "node_modules", "vue")
  return vim.fn.isdirectory(vue_path) == 1
end

-- requires vue_ls > 2.0
local function setup_vue_ls(opts)
  opts.servers = opts.servers or {}
  opts.servers.ts_ls = { enabled = false }
  opts.servers.vue_ls = {
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "json",
    },
    init_options = {
      typescript = {
        tsdk = "/home/main/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib",
      },
      vue = {
        hybridMode = false,
      },
    },
  }
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
      vim.list_extend(opts.ensure_installed, { "vue_ls" })
    end,
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
        setup_vue_ls(opts)
      end
    end,
  },
}
