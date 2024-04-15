-- basic keymaps
-- plugin-related keymaps may occur in plugin config

local set = vim.keymap.set

set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Cycle buffers
set("n", "<A-tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
set("n", "<C-tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Navigate back/forward
set(
  { "n", "i", "v" },
  "<A-Left>",
  "<C-o>",
  { noremap = true, silent = true, desc = "Go back" }
)
set(
  { "n", "i", "v" },
  "<A-Right>",
  "<C-i>",
  { noremap = true, silent = true, desc = "Go forward" }
)

-- maps Ctrl+Backspace(C-H) to Ctrl+W(remove word)
set({ "n", "i", "v", "t" }, "<C-H>", "<C-W>", { noremap = true })

-- Ctrl+Arrows to move word
set("n", "<C-Right>", "e", { desc = "Jump word forward" })
set("n", "<C-Left>", "b", { desc = "Jump word back" })
-- set("n", "<C-.>", "<cmd>Git diffthis<cr><cmd>Neotree git_status<cr>", { desc = "git explorer + diffsplit" })

set(
  { "i", "n", "v", "x" },
  "<C-s>",
  "<cmd>stopinsert<CR><cmd>w<CR>",
  { desc = "Save file" }
)
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

set(
  "n",
  "+",
  "<cmd>vertical resize +5<CR>",
  { desc = "Increase vertical size of window" }
)
set(
  "n",
  "-",
  "<cmd>vertical resize -5<CR>",
  { desc = "Decrease vertical size of window" }
)
set(
  "n",
  "?",
  "<cmd>horizontal resize +5<CR>",
  { desc = "Increase horizontal size of window" }
)
set(
  "n",
  "_",
  "<cmd>horizontal resize -5<CR>",
  { desc = "Decrease horizontal size of window" }
)

-- set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
set(
  { "n", "t", "i", "v", "x" },
  "<A-tab>",
  "<cmd>bnext<CR>",
  { desc = "Go to next tab" }
) --  go to next tab
set(
  { "n", "t", "i", "v", "x" },
  "<S-tab>",
  "<cmd>bprevious<CR>",
  { desc = "Go to previous tab" }
) --  go to previous tab
set(
  "n",
  "<leader>tf",
  "<cmd>tabnew %<CR>",
  { desc = "Open current buffer in new tab" }
) --  move current buffer to new tab

set("v", "<tab>", ">", { desc = "Indent" })
set("v", "<S-tab>", "<", { desc = "Remove indent" })
