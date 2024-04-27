local M = {}

function M.index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

function M.next_index(current_index, max_index)
  return (current_index % max_index) + 1
end

function M.previous_index(current_index, max_index)
  return ((current_index - 2 + max_index) % max_index) + 1
end

function M.get_visual_selection()
  local vstart = vim.fn.getcharpos("v")
  local line_start, char_start = vstart[2], vstart[3]
  local vend = vim.fn.getcharpos(".")
  local line_end, char_end = vend[2], vend[3]

  local result = {}

  for line = line_start, line_end do
    local text
    if line == line_start and line == line_end then
      text = string.sub(vim.fn.getline(line), char_start, char_end)
    elseif line == line_start then
      text = string.sub(vim.fn.getline(line), char_start)
    elseif line == line_end then
      text = string.sub(vim.fn.getline(line), 1, char_end)
    else
      text = vim.fn.getline(line)
    end
    table.insert(result, text)
  end

  return table.concat(result, "\n")
end

return M
