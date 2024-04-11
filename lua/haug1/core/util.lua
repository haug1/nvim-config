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

return M
