local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local Job = require("plenary.job")

local M = {}

function M.repos_file()
  local repo_dir = "/home/main/repos"
  M.main(repo_dir, require("telescope.builtin").find_files)
end

function M.repos_grep()
  local repo_dir = "/home/main/repos"
  M.main(repo_dir, require("telescope.builtin").live_grep)
end

---@param telescope_fn function
function M.main(dir, telescope_fn)
  local data = nil

  Job:new({
    command = "fd",
    args = { "--type", "directory", "--prune" },
    cwd = dir,
    on_exit = function(j)
      data = j:result()
    end,
  }):sync()

  if data ~= type(data) == "table" and #data > 0 then
    M.dirjump(data, dir, telescope_fn)
  else
    print(
      "telescope-dirjump: No directories found in the given root directory."
    )
  end
end

---@param telescope_fn function
function M.dirjump(data, dir, telescope_fn)
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
end

return M
