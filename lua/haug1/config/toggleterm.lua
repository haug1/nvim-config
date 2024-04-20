-- implements cycling between terminals and other QoL features for terminals
-- adds terminal keymaps
-- based on https://github.com/akinsho/toggleterm.nvim

local util = require("haug1.core.util")
local Terminal = require("toggleterm.terminal").Terminal

local terminal_id_counter = 0
local selected_terminal = terminal_id_counter
local terminals = {}
local remember_direction = "float"
local lazygit_terminal = nil

local M = {}

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

  vim.keymap.set("t", "<S-space>", "<space>") -- otherwise it prints ;2u, which i never need, even when i misclick
  vim.keymap.set("t", "<S-backspace>", "<backspace>") -- prints 7;2u

  -- activate tmux navigation in terminal mode
  local map = function(key, cmd, nav)
    vim.keymap.set({ "t" }, key, function()
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

  -- disable buffer cycling in terminal
  vim.keymap.set({"n","i","v","x"}, "<A-tab>", "<A-tab>", {noremap = true, buffer = terminal.bufnr})
  vim.keymap.set({"n","i","v","x"}, "<S-tab>", "<S-tab>", {noremap = true, buffer = terminal.bufnr})
  -- stylua: ignore end
end

function M.open_lazygit()
  lazygit_terminal = Terminal:new({
    cmd = "lazygit",
  })
  lazygit_terminal:open(nil, "float")
end

function M.close_lazygit()
  if lazygit_terminal ~= nil then
    lazygit_terminal:shutdown()
    lazygit_terminal = nil
  end
end

function M.print_active()
  print("Terminal #" .. util.index_of(terminals, selected_terminal))
end

function M.on_create_terminal(terminal)
  M.on_create_keymaps(terminal)
  table.insert(terminals, terminal.id)
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = terminal.bufnr,
    callback = function()
      print("TermOpen")
      vim.cmd.startinsert()
      -- vim.defer_fn(vim.cmd.startinsert, 0)
    end,
  })
  vim.api.nvim_create_autocmd("TermClose", {
    once = true,
    buffer = terminal.bufnr,
    callback = function()
      local current_index = util.index_of(terminals, terminal.id)
      if selected_terminal == terminal.id then
        local new_index = util.previous_index(current_index, #terminals)
        selected_terminal = terminals[new_index]
      end
      table.remove(terminals, current_index)
      print("Disposed terminal, " .. #terminals .. " still open.")
    end,
  })
end

function M.upsert_terminal(number)
  local terminal = Terminal:new({ id = number })
  if terminal:is_open() then
    terminal:close()
  else
    terminal:open(nil, remember_direction)
    if not util.index_of(terminals, terminal.id) then
      M.on_create_terminal(terminal)
    end
    selected_terminal = terminal.id
    M.print_active()
  end
  return terminal
end

function M.new()
  vim.cmd.close()
  local terminal_id = terminal_id_counter + 1
  terminal_id_counter = terminal_id
  M.upsert_terminal(terminal_id)
end

function M.toggle()
  M.upsert_terminal(selected_terminal)
end

function M.cycle(back)
  if #terminals > 1 then
    local find_index = back and util.previous_index or util.next_index
    vim.cmd.close()
    local current_index = util.index_of(terminals, selected_terminal)
    selected_terminal = terminals[find_index(current_index, #terminals)]
    M.toggle()
  end
end

function M.cycle_forward()
  M.cycle(false)
end

function M.cycle_back()
  M.cycle(true)
end

function M.resize(direction)
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

function M.toggle_vertical()
  M.resize("vertical")
end

function M.toggle_horizontal()
  M.resize("horizontal")
end

return M
