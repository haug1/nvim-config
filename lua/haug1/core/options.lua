vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw early (before it loads) so nvim-tree owns directories
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
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
vim.o.title = true
vim.o.titlestring =
  "%{printf('nvim - %s', empty(expand('%:~')) ? fnamemodify(getcwd(), ':~') : expand('%:~'))}"
