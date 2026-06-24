return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vue" })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
      -- Vue Language Server v3 only supports "hybrid mode": vue_ls handles
      -- the template/style sections while the TypeScript server handles
      -- <script> via @vue/typescript-plugin. We therefore extend the shared
      -- vtsls server (defined in typescript.lua) rather than running a second
      -- TS server inside vue_ls (which would cause duplicate completions).
      opts.servers = opts.servers or {}

      local vue_language_server_path = vim.fn.expand(
        "$MASON/packages/vue-language-server/node_modules/@vue/language-server"
      )

      local vtsls = opts.servers.vtsls or {}

      -- Attach vtsls to .vue files as well.
      vtsls.filetypes = vtsls.filetypes or {}
      table.insert(vtsls.filetypes, "vue")

      -- Load the Vue TypeScript plugin into vtsls' tsserver.
      vtsls.settings = vtsls.settings or {}
      vtsls.settings.vtsls = vtsls.settings.vtsls or {}
      vtsls.settings.vtsls.tsserver = vtsls.settings.vtsls.tsserver or {}
      vtsls.settings.vtsls.tsserver.globalPlugins = vtsls.settings.vtsls.tsserver.globalPlugins
        or {}
      table.insert(vtsls.settings.vtsls.tsserver.globalPlugins, {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      })

      opts.servers.vtsls = vtsls

      -- vue_ls needs no extra config: the tsserver<->vue_ls request bridge
      -- is shipped by nvim-lspconfig's lsp/vue_ls.lua.
      opts.servers.vue_ls = {}
    end,
  },
}
