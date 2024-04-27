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
          file_ignore_patterns = {
            "node_modules/.*",
            "yarn.lock",
            "package%-lock.json",
            "lazy%-lock.json",
            "target/.*",
            ".git/.*",
          },
          mappings = {
            i = {
              ["<C-k>"] = move_next,
              ["<C-j>"] = move_prev,
            },
          },
        },
        pickers = {
          find_files = {
            follow = true,
            hidden = true,
          },
        },
        extensions = {
          file_browser = {},
        },
      })

      telescope.load_extension("fzf")

      local set = vim.keymap.set
      -- stylua: ignore start
      set("n", "<leader><leader>", builtin.find_files, { desc = "Find files (Telescope)" })
      set("n", "<leader>sf", builtin.find_files, { desc = "Find files (Telescope)" })
      set("n", "<leader>sg", builtin.live_grep, { desc = "Live grep (Telescope)" })
      set("n", "<leader>sb", builtin.buffers, { desc = "Buffers (Telescope)" })
      set("n", "<leader>sh", builtin.help_tags, { desc = "Help tags (Telescope)" })
      set("n", "<leader>sr", builtin.oldfiles, { desc = "Recent files (Telescope)" })
      set({ "n", "v" }, "<leader>sk", builtin.keymaps, { desc = "Keymaps (Telescope)" })

      local haug1_builtins = require("haug1.config.telescope")
      set("n", "<leader>sc", haug1_builtins.config_files, { desc = "Config files (Telescope)" })
      set("n", "<leader>sR", haug1_builtins.repos_grep, { desc = "Live grep in selected repository (Telescope)" })
      set("n", "<leader>sF", haug1_builtins.repos_files, { desc = "Browse files in selected repository (Telescope)" })
      -- stylua: ignore end
    end,
  },
}
