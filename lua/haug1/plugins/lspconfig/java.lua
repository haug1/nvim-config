return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        java_language_server = {
          -- cmd = "/home/main/.local/share/nvim/mason/packages/java-language-server/java-language-server",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "java_language_server",
      })
    end,
  },
}
