local M = {}

function M.delete_other_buffers()
  local current_buffer = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    if bufnr ~= current_buffer and vim.fn.buflisted(bufnr) == 1 then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
  require("lualine").refresh()
end

function M.new_buffer()
  vim.cmd.enew()
end

function M.get_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      table.insert(
        buffers,
        { buf = buf, name = vim.api.nvim_buf_get_name(buf) }
      )
    end
  end
  return buffers
end

return M
