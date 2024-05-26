-- NOTE: FUCK VUE LSP WE PINNED AT 1.8

local function is_vue_project()
  local current_path = vim.fn.expand("%:p:h")
  local util = require("lspconfig.util")
  local project_root = util.find_node_modules_ancestor(current_path)
  local vue_path = util.path.join(project_root, "node_modules", "vue")
  return vim.fn.isdirectory(vue_path) == 1
end

-- working
-- requires volar < 2.0
local function setup_volar_old_takeover(opts)
  opts.servers = opts.servers or {}
  opts.servers.tsserver = { enabled = false }
  opts.servers.volar = {
    filetypes = {
      "vue",
      "javascript",
      "javascript.jsx",
      "typescript",
      "typescript.tsx",
      "javascriptreact",
      "typescriptreact",
      "json",
    },
  }
end

-- -- not working
-- -- requires volar > 2.0
-- local function setup_volar_new_hybrid(opts)
--   local get_package = require("mason-registry").get_package
--   opts.servers.volar = {}
--   opts.servers.tsserver = {
--     init_options = {
--       plugins = {
--         {
--           name = "@vue/typescript-plugin",
--           location = get_package("vue-language-server"):get_install_path()
--             .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
--           languages = { "javascript", "typescript", "vue" },
--         },
--       },
--       tsserver = {
--         path = get_package("typescript-language-server"):get_install_path()
--           .. "/node_modules/typescript/lib",
--       },
--     },
--     filetypes = { "javascript", "typescript", "vue" },
--   }
-- end

-- -- not working
-- -- requires volar > 2.0
local function setup_volar_new_takeover(opts)
  opts.servers = opts.servers or {}
  opts.servers.tsserver = { enabled = false }
  opts.servers.volar = {
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "json",
    },
    init_options = {
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
      vim.list_extend(opts.ensure_installed, { "volar@1.8.27" })
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
        setup_volar_new_takeover(opts)
      end
    end,
  },
}
