require("haug1.core.options")
require("haug1.core.keymaps")
require("haug1.core.autocmds")
require("haug1.core.lazy")
require("lazy").setup({
  { import = "haug1.plugins" },
  { import = "haug1.plugins.lspconfig" },
  -- TODO: dap
})
