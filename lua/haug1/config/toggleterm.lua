-- configures toggleterm and extends it with terminal cycling
-- adds terminal keymaps

require("toggleterm").setup({
  persist_mode = false,
  start_in_insert = false,
  on_open = function()
    -- workaround: always insert mode when terminal opened
    vim.fn.timer_start(1, function()
      vim.cmd("startinsert!")
    end)
  end,
  size = function(term)
    if term.direction == "horizontal" then
      return math.floor(vim.o.lines * 0.3)
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  float_opts = {
    width = function()
      return math.floor(vim.o.columns * 0.9)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.9)
    end,
  },
})

local Util = require("haug1.core.util")
local Terminal = require("toggleterm.terminal").Terminal

local lazygit_terminal = nil
local function open_lazygit()
  lazygit_terminal = Terminal:new({
    cmd = "lazygit",
  })
  lazygit_terminal:open(nil, "float")
end

local function close_lazygit()
  if lazygit_terminal ~= nil then
    lazygit_terminal:shutdown()
    lazygit_terminal = nil
  end
end

---@type number
local terminal_id_counter = 0

---@type number
local selected_terminal = terminal_id_counter

---@type number[]
local terminals = {}

local remember_direction = "float"

local function index_of_terminal(terminal_id)
  return Util.index_of(terminals, terminal_id)
end

local function print_active()
  print("Terminal #" .. index_of_terminal(selected_terminal))
end

local function upsert_terminal(number)
  local terminal = Terminal:new({ id = number })
  terminal:open(nil, remember_direction)
  local is_new = not index_of_terminal(terminal.id)
  if is_new then
    vim.keymap.set(
      "t",
      "<esc><esc>",
      vim.cmd.stopinsert,
      { desc = "Stop insert mode", buffer = terminal.bufnr }
    )
    table.insert(terminals, terminal.id)
    vim.api.nvim_create_autocmd("TermClose", {
      once = true,
      buffer = terminal.bufnr,
      callback = function()
        local current_index = index_of_terminal(terminal.id)
        if selected_terminal == terminal.id then
          local new_index = Util.previous_index(current_index, #terminals)
          selected_terminal = terminals[new_index]
        end
        table.remove(terminals, current_index)
        print("Disposed terminal, " .. #terminals .. " still open.")
      end,
    })
  end
  selected_terminal = terminal.id
  print_active()
  return terminal
end

local function new()
  vim.cmd.close()
  local terminal_id = terminal_id_counter + 1
  terminal_id_counter = terminal_id
  upsert_terminal(terminal_id)
end

local function toggle()
  upsert_terminal(selected_terminal)
end

local function cycle(back)
  if #terminals > 1 then
    local find_index = back and Util.previous_index or Util.next_index
    vim.cmd.close()
    local current_index = index_of_terminal(selected_terminal)
    selected_terminal = terminals[find_index(current_index, #terminals)]
    toggle()
  end
end

local function cycle_forward()
  cycle(false)
end

local function cycle_back()
  cycle(true)
end

local function resize(direction)
  local terminal = Terminal:new({ id = selected_terminal })
  local is_current_direction = direction == terminal.direction
  vim.cmd.close()
  if is_current_direction then
    remember_direction = "float"
  else
    remember_direction = direction
  end
  terminal:toggle(nil, remember_direction)
end

local function toggle_vertical()
  resize("vertical")
end

local function toggle_horizontal()
  resize("horizontal")
end

-- dont print stuff to terminal when accidentally holding shift
vim.keymap.set("t", "<S-space>", "<space>") -- prints ;2u
vim.keymap.set("t", "<S-backspace>", "<backspace>") -- prints 7;2u

vim.keymap.set(
  { "n", "i", "v" },
  "<C-t>",
  toggle,
  { noremap = true, desc = "Show terminal" }
)
vim.keymap.set(
  "t",
  "<C-t>",
  vim.cmd.close,
  { desc = "Hide Terminal", noremap = true }
)
vim.keymap.set("t", "<C-n>", new, { desc = "New terminal", noremap = true })
vim.keymap.set(
  "t",
  "<C-.>",
  cycle_forward,
  { noremap = true, desc = "Next terminal" }
)
vim.keymap.set("t", "<C-,>", cycle_back, { desc = "Previous terminal" })
vim.keymap.set("n", "<C-\\>", open_lazygit, { desc = "Toggle lazygit" })
vim.keymap.set(
  "t",
  "<C-\\>",
  close_lazygit,
  { desc = "Close lazygit (if exists)" }
)
vim.keymap.set("t", "<C-S-j>", toggle_horizontal, { desc = "Resize" })
vim.keymap.set("t", "<C-S-h>", toggle_vertical, { desc = "Resize" })
