vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.winbar = "%=%m %f"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
