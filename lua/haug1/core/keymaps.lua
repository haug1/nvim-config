-- basic keymaps
-- plugin-related keymaps may occur in plugin config

-- stylua: ignore start
-- We're on our own /salute

local set = vim.keymap.set

set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navigate back/forward
set({ "n", "i", "v" }, "<A-Left>", "<C-o>", { noremap = true, silent = true, desc = "Go back" })
set({ "n", "i", "v" }, "<A-Right>", "<C-i>", { noremap = true, silent = true, desc = "Go forward" })

-- maps Ctrl+Backspace(C-H) to Ctrl+W(remove word)
set({ "n", "i", "v", "t" }, "<C-H>", "<C-W>", { noremap = true })

-- Ctrl+Arrows to move word
set("n", "<C-Right>", "e", { desc = "Jump word forward" })
set("n", "<C-Left>", "b", { desc = "Jump word back" })
-- set("n", "<C-.>", "<cmd>Git diffthis<cr><cmd>Neotree git_status<cr>", { desc = "git explorer + diffsplit" })

set({ "i", "n", "v", "x" }, "<C-s>", "<cmd>stopinsert<CR><cmd>w<CR>", { desc = "Save file" })

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- window management
set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
set("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

set("n", "+", "<cmd>vertical resize +5<CR>", { desc = "Increase vertical size of window" })
set("n", "-", "<cmd>vertical resize -5<CR>", { desc = "Decrease vertical size of window" })
set("n", "?", "<cmd>horizontal resize +5<CR>", { desc = "Increase horizontal size of window" })
set("n", "_", "<cmd>horizontal resize -5<CR>", { desc = "Decrease horizontal size of window" })

-- set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

local builtins = require("haug1.config.buffers")
set( { "n", "i", "v", "x" }, "<c-tab>", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
set( { "n", "i", "v", "x" }, "<c-s-tab>", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" }) --  go to previous buffer
set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" }) --  delete current buffer
set("n", "<leader>bo", builtins.delete_other_buffers, { desc = "Delete all other buffers" })
set("n", "<leader>bn", builtins.new_buffer, { desc = "New buffer" })

set("v", "<tab>", ">", { desc = "Indent" })
set("v", "<S-tab>", "<", { desc = "Remove indent" })
set({ "i", "t" }, "<A-h>", "<Left>", { desc = "Arrow left", remap = false })
set({ "i", "t" }, "<A-j>", "<Down>", { desc = "Arrow down", remap = false })
set({ "i", "t" }, "<A-k>", "<Up>", { desc = "Arrow up", remap = false })
set({ "i", "t" }, "<A-l>", "<Right>", { desc = "Arrow right", remap = false })

set("n", "gd", "gdzz")
set("n", "n", "nzz")
set("n", "N", "Nzz")
set("n", "<C-o>", "<C-o>zz")
set("n", "<C-i>", "<C-i>zz")

local function next_error()
  vim.diagnostic.goto_next({
    severity = vim.diagnostic.severity.ERROR,
  })
end
local function prev_error()
  vim.diagnostic.goto_next({
    severity = vim.diagnostic.severity.ERROR,
  })
end

-- stylua: ignore start
set("n", "<leader>dp", prev_error, { desc = "Go to previous error [D]iagnostic message" })
set("n", "<leader>dP", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
set("n", "<leader>dn", next_error, { desc = "Go to next error [D]iagnostic message" })
set("n", "<leader>dN", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
-- stylua: ignore end
