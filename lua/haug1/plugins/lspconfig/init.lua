return {
  -- mason_lspconfig.setup({
  --   -- list of servers for mason to install
  --   ensure_installed = {
  --     "terraformls",
  --     "emmet_ls",
  --     "ocamllsp",
  --   },
  -- })

  -- mason_tool_installer.setup({
  --   ensure_installed = {
  --     "tflint",
  --     "shfmt",
  --   },
  -- })
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    priority = 5,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "bashls", "jsonls" })
    end,
    config = function(_, opts)
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-lspconfig").setup(opts)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    priority = 5,
    opts = { ensure_installed = {} },
  },
  {
    "neovim/nvim-lspconfig",
    priority = 5, -- priority makes sure mason and lang specific config is already available
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "kickstart-lsp-attach",
          { clear = true }
        ),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set(
              "n",
              keys,
              func,
              { buffer = event.buf, desc = "LSP: " .. desc }
            )
          end

          local telescope_builtin = require("telescope.builtin")
          map("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")
          map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
          map(
            "gI",
            telescope_builtin.lsp_implementations,
            "[G]oto [I]mplementation"
          )
          map(
            "<leader>D",
            telescope_builtin.lsp_type_definitions,
            "Type [D]efinition"
          )
          map(
            "<leader>ds",
            telescope_builtin.lsp_document_symbols,
            "[D]ocument [S]ymbols"
          )
          map(
            "<leader>ws",
            telescope_builtin.lsp_dynamic_workspace_symbols,
            "[W]orkspace [S]ymbols"
          )
          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client and client.server_capabilities.documentHighlightProvider
          then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local server = opts.servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend(
            "force",
            {},
            capabilities,
            server.capabilities or {}
          )

          -- expose possibility to run my own custom setup function from the opts
          if type(server.my_setup_func) == "function" then
            server.my_setup_func()
            server.my_setup_func = nil
          end

          require("lspconfig")[server_name].setup(server)
        end,
      })
    end,
  },
}
