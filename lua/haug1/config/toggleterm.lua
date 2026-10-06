-- Terminal keymaps and cycling on top of toggleterm.nvim.

local util = require("haug1.core.util")
local toggleterm = require("toggleterm.terminal")
local Terminal = toggleterm.Terminal

local remember_direction = "float"
local lazygit_terminal
local current_toggleterm

local M = {}

local function get_terminal(id)
  if not id then
    return nil
  end
  return toggleterm.get(id, true)
end

local function set_selected(id)
  vim.g.haug1_toggleterm_selected = id
end

local function resolve_selected()
  local terminals = toggleterm.get_all()
  local selected_id = vim.g.haug1_toggleterm_selected

  for index, terminal in ipairs(terminals) do
    if terminal.id == selected_id then
      return terminal, index, terminals
    end
  end

  if #terminals == 0 then
    set_selected(nil)
    return nil, nil, terminals
  end

  -- Recover cleanly if the selected job exited or this module was reloaded.
  local current = current_toggleterm and current_toggleterm()
  for index, terminal in ipairs(terminals) do
    if terminal == current then
      set_selected(terminal.id)
      return terminal, index, terminals
    end
  end

  local terminal = terminals[#terminals]
  set_selected(terminal.id)
  return terminal, #terminals, terminals
end

local function is_open(terminal)
  if terminal.window and not vim.api.nvim_win_is_valid(terminal.window) then
    terminal.window = nil
  end
  return terminal:is_open()
end

local function setup_terminal_keymaps(terminal)
  M.on_create_keymaps(terminal)
end

current_toggleterm = function()
  for _, terminal in ipairs(toggleterm.get_all(true)) do
    if is_open(terminal) and terminal:is_focused() then
      return terminal
    end
  end
end

function M.default_keymaps()
  -- stylua: ignore start
  vim.keymap.set({ "n", "i", "v", "t" }, "<C-t>", M.toggle, { noremap = true, desc = "Show terminal" })
  vim.keymap.set("t", "<C-n>", M.new, { desc = "New terminal", noremap = true })
  vim.keymap.set("t", "<C-.>", M.cycle_forward, { noremap = true, desc = "Next terminal" })
  vim.keymap.set("t", "<C-,>", M.cycle_back, { desc = "Previous terminal" })
  vim.keymap.set("n", "<C-\\>", M.open_lazygit, { desc = "Toggle lazygit", noremap = true })
  vim.keymap.set("t", "<C-\\>", M.close_lazygit, { desc = "Close lazygit (if exists)", noremap = true })
  vim.keymap.set("t", "<C-S-j>", M.toggle_horizontal, { desc = "Resize" })
  vim.keymap.set("t", "<C-S-h>", M.toggle_vertical, { desc = "Resize" })

  vim.keymap.set("t", "<S-space>", "<space>")
  vim.keymap.set("t", "<S-backspace>", "<backspace>")

  local function map(key, cmd, nav)
    vim.keymap.set("t", key, function()
      vim.cmd.stopinsert()
      vim.cmd(cmd)
    end, { desc = "TmuxNavigate " .. nav, noremap = true })
  end
  map("<c-h>", "TmuxNavigateLeft", "Left")
  map("<c-j>", "TmuxNavigateDown", "Down")
  map("<c-l>", "TmuxNavigateRight", "Right")
  map("<c-k>", "TmuxNavigateUp", "Up")
  map("<c-q>", "TmuxNavigatePrevious", "Previous")
  -- stylua: ignore end
end

function M.on_create_keymaps(terminal)
  -- stylua: ignore start
  vim.keymap.set("t", "<esc><esc>", vim.cmd.stopinsert, { desc = "Stop insert mode", buffer = terminal.bufnr })

  -- Keep terminal buffers from interpreting these as buffer navigation.
  vim.keymap.set({ "n", "i", "v", "x" }, "<A-tab>", "<A-tab>", { noremap = true, buffer = terminal.bufnr })
  vim.keymap.set({ "n", "i", "v", "x" }, "<S-tab>", "<S-tab>", { noremap = true, buffer = terminal.bufnr })
  -- stylua: ignore end
end

function M.open_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit is not available on PATH", vim.log.levels.WARN)
    return
  end

  lazygit_terminal = lazygit_terminal
    or Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

  if is_open(lazygit_terminal) then
    lazygit_terminal:close()
  else
    lazygit_terminal:open(nil, "float")
  end
end

function M.close_lazygit()
  if lazygit_terminal and is_open(lazygit_terminal) then
    lazygit_terminal:close()
  end
end

function M.upsert_terminal(id)
  if not id then
    return M.new()
  end

  local terminal = get_terminal(id)
  if not terminal then
    return M.new()
  end
  if is_open(terminal) then
    if terminal:is_focused() then
      terminal:close()
    else
      terminal:focus()
    end
  else
    terminal:open(nil, remember_direction)
    setup_terminal_keymaps(terminal)
  end

  set_selected(terminal.id)
  return terminal
end

function M.new()
  -- Hide a terminal only when it is the current window; never close an
  -- unrelated editor split just to make room for a new terminal.
  local current = current_toggleterm()
  if current then
    current:close()
  end

  -- Let toggleterm allocate IDs so custom terminals (such as lazygit) cannot
  -- collide with a separate hand-maintained counter.
  local terminal = Terminal:new()
  terminal:open(nil, remember_direction)
  setup_terminal_keymaps(terminal)
  set_selected(terminal.id)
  return terminal
end

function M.toggle()
  local terminal = resolve_selected()
  if not terminal then
    return M.new()
  end
  return M.upsert_terminal(terminal.id)
end

function M.cycle(back)
  local current, current_index, terminals = resolve_selected()
  if #terminals < 2 then
    return
  end

  if current and is_open(current) then
    current:close()
  end

  local next_index = back
      and util.previous_index(current_index, #terminals)
    or util.next_index(current_index, #terminals)
  local next_terminal = terminals[next_index]
  set_selected(next_terminal.id)
  if is_open(next_terminal) then
    next_terminal:focus()
  else
    next_terminal:open(nil, remember_direction)
    setup_terminal_keymaps(next_terminal)
  end
end

function M.cycle_forward()
  M.cycle(false)
end

function M.cycle_back()
  M.cycle(true)
end

function M.resize(direction)
  local terminal = resolve_selected()
  if not terminal then
    return M.new()
  end

  local same_direction = direction == terminal.direction
  remember_direction = same_direction and "float" or direction

  if is_open(terminal) then
    terminal:close()
  end
  terminal:open(nil, remember_direction)
  setup_terminal_keymaps(terminal)
end

function M.toggle_vertical()
  M.resize("vertical")
end

function M.toggle_horizontal()
  M.resize("horizontal")
end

return M
