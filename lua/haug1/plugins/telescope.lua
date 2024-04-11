return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local move_next = actions.move_selection_next
      local move_prev = actions.move_selection_previous

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = move_next,
              ["<C-k>"] = move_prev,
            },
          },
        },
        pickers = {
          find_files = {
            follow = true,
            hidden = true,
          },
        },
      })

      telescope.load_extension("fzf")

      local set = vim.keymap.set
      set(
        "n",
        "<leader><leader>",
        builtin.find_files,
        { desc = "Find files (Telescope)" }
      )
      set(
        "n",
        "<leader>sf",
        builtin.find_files,
        { desc = "Find files (Telescope)" }
      )
      set(
        "n",
        "<leader>sg",
        builtin.live_grep,
        { desc = "Live grep (Telescope)" }
      )
      set("n", "<leader>sb", builtin.buffers, { desc = "Buffers (Telescope)" })
      set(
        "n",
        "<leader>sh",
        builtin.help_tags,
        { desc = "Help tags (Telescope)" }
      )
      set(
        "n",
        "<leader>sr",
        builtin.oldfiles,
        { desc = "Recent files (Telescope)" }
      )
      set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps (Telescope)" })
      set(
        "n",
        "<leader>sc",
        "<cmd>lua require('telescope.builtin').find_files({cwd='~/.config/nvim-wip'})<cr>",
        { desc = "Config files (Telescope)" }
      )
    end,
  },
}
