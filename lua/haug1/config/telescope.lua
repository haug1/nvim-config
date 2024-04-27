local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local repos_dir = vim.fn.expand("$HOME/repos")
local config_dir = vim.fn.expand("$HOME/.config")

local M = {}

function M.config_files()
  builtin.find_files({ cwd = config_dir })
end

function M.repos_grep()
  M.dirjump_grep(repos_dir)
end

function M.repos_files()
  M.dirjump_file(repos_dir)
end

function M.dirjump_file(dir)
  M.dirjump(dir, builtin.find_files)
end

function M.dirjump_grep(dir)
  M.dirjump(dir, builtin.live_grep)
end

--- Lists the directories of the specified location
--- and runs telescope_fn(i.e. find_files) in that directory.
---@param telescope_fn function
function M.dirjump(dir, telescope_fn)
  pickers
    .new({}, {
      finder = finders.new_oneshot_job(
        { "fd", "--type", "directory", "--prune" },
        { cwd = dir }
      ),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(dir_prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(dir_prompt_bufnr)
          local dir_selection = action_state.get_selected_entry()
          telescope_fn({
            cwd = dir .. "/" .. dir_selection.value,
            attach_mappings = function(file_prompt_bufnr)
              actions.select_default:replace(function()
                -- set selected directory as new directory
                vim.cmd.cd(dir .. "/" .. dir_selection.value)
                action_set.edit(file_prompt_bufnr, "edit")
                -- center on search result, i.e. relevant in case of live_grep
                vim.cmd([[normal! zz]])
              end)
              return true
            end,
          })
        end)
        return true
      end,
    })
    :find()
end

return M
