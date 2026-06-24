-- Treesitter incremental selection.
--
-- The nvim-treesitter `main` branch dropped the incremental_selection module
-- (deliberately, with no plans to restore it), so this reimplements it on top
-- of core `vim.treesitter`:
--   <C-space> (normal)  -> select the node under the cursor
--   <C-space> (visual)  -> grow to the next-larger named node
--   <bs>      (visual)  -> shrink back to the previous selection
--
-- Ranges are {start_row, start_col, end_row, end_col}, 0-indexed, end-exclusive
-- (the shape returned by TSNode:range()).

local M = {}

-- per-buffer stack of ranges; top of stack is the current selection
local stacks = {}

local function cur_buf()
  return vim.api.nvim_get_current_buf()
end

local function ranges_equal(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

-- does `outer` fully contain `inner`?
local function range_contains(outer, inner)
  local start_ok = outer[1] < inner[1]
    or (outer[1] == inner[1] and outer[2] <= inner[2])
  local end_ok = outer[3] > inner[3]
    or (outer[3] == inner[3] and outer[4] >= inner[4])
  return start_ok and end_ok
end

-- visually (charwise) select a 0-indexed, end-exclusive range
local function select_range(range)
  local sr, sc, er, ec = range[1], range[2], range[3], range[4]

  -- convert end to an inclusive 0-indexed cursor position
  local end_row, end_col
  if ec == 0 and er > sr then
    -- range ends at column 0 of `er` => last selected byte is on the prev line
    end_row = er - 1
    local line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1]
      or ""
    end_col = math.max(#line - 1, 0)
  else
    end_row = er
    end_col = math.max(ec - 1, 0)
  end

  -- clamp columns to valid byte indices for nvim_win_set_cursor
  local function clamp(row, col)
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
    return math.max(0, math.min(col, math.max(#line - 1, 0)))
  end

  -- leave any active visual mode before re-selecting
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("normal! \27")
  end

  vim.api.nvim_win_set_cursor(0, { sr + 1, clamp(sr, sc) })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row + 1, clamp(end_row, end_col) })
end

-- walk up from the leaf at the range start to the first named ancestor whose
-- range strictly contains `range`
local function grow(range)
  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr = cur_buf(),
    pos = { range[1], range[2] },
  })
  if not ok or not node then
    return nil
  end
  while node do
    local r = { node:range() }
    if range_contains(r, range) and not ranges_equal(r, range) then
      return r
    end
    node = node:parent()
  end
  return nil
end

function M.init()
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = cur_buf() })
  if not ok or not node then
    return
  end
  local r = { node:range() }
  stacks[cur_buf()] = { r }
  select_range(r)
end

function M.expand()
  local stack = stacks[cur_buf()]
  if not stack or #stack == 0 then
    return M.init()
  end
  local bigger = grow(stack[#stack])
  if bigger then
    table.insert(stack, bigger)
    select_range(bigger)
  end
end

function M.shrink()
  local stack = stacks[cur_buf()]
  if not stack or #stack < 2 then
    return
  end
  table.remove(stack)
  select_range(stack[#stack])
end

function M.setup()
  vim.keymap.set("n", "<C-space>", M.init, { desc = "TS: init selection" })
  vim.keymap.set("x", "<C-space>", M.expand, { desc = "TS: expand selection" })
  vim.keymap.set("x", "<bs>", M.shrink, { desc = "TS: shrink selection" })
end

return M
