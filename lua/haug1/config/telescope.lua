local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

function M.dirjump_file(dir)
  M.dirjump(dir, builtin.find_files)
end

function M.dirjump_grep(dir)
  M.dirjump(dir, builtin.live_grep)
end

---@param telescope_fn function
function M.dirjump(dir, telescope_fn)
  pickers
    .new({}, {
      finder = finders.new_oneshot_job(
        { "fd", "--type", "directory", "--prune" },
        {
          cwd = dir,
        }
      ),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          telescope_fn({
            cwd = dir .. "/" .. selection.value,
          })
          -- TODO: Set cwd to new repo on file selected
        end)
        return true
      end,
    })
    :find()
end

return M
