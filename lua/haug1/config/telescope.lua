local Job = require("plenary.job")
local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local make_entry = require("telescope.make_entry")
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
  local data = nil

  Job:new({
    command = "fd",
    args = { "--type", "directory", "--prune" },
    cwd = dir,
    on_exit = function(j)
      data = j:result()
    end,
  }):sync()

  if data ~= nil and type(data) == "table" and #data > 0 then
    pickers
      .new({}, {
        finder = finders.new_table({
          results = data,
          entry_maker = make_entry.gen_from_file(),
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            telescope_fn({
              cwd = dir .. "/" .. selection.value,
            })
          end)
          return true
        end,
      })
      :find()
  else
    print(
      "telescope-dirjump: No directories found in the given root directory."
    )
  end
end

return M
