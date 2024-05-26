require("haug1.core.options")
require("haug1.core.keymaps")
require("haug1.core.autocmds")
require("haug1.core.lazy")
require("lazy").setup({
  spec = {
    { import = "haug1.plugins" },
    { import = "haug1.plugins.lspconfig" },
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
