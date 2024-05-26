local copilot_enabled = true

local function toggle_copilot()
  copilot_enabled = not copilot_enabled
  if copilot_enabled then
    vim.cmd("Copilot enable")
    print("Copilot enabled")
  else
    vim.cmd("Copilot disable")
    print("Copilot disabled")
  end
end

vim.g.copilot_enabled = false

local function oneshot_copilot()
  vim.cmd("Copilot enable")
  vim.cmd("Copilot disable")
  print("toggled copilot")
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>uc", toggle_copilot, { noremap = true, silent = true })
vim.keymap.set("i", "<c-i>", oneshot_copilot, { noremap = true, silent = true })
-- stylua: ignore end

return {
  { "github/copilot.vim" },
}
