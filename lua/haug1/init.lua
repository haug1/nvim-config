-- plugins with no configuration are only found here
-- others have their own file as well
local function create_import(name)
  return {
    import = "haug1.plugins." .. name,
  }
end

require("haug1.core.options")
require("haug1.core.keymaps")
require("haug1.core.autocmds")
require("haug1.lazy")
require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "tpope/vim-sleuth",
  { "numToStr/Comment.nvim", opts = {} },
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-q>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    opts = function(_, __)
      -- NOTE: Do not set default mappings
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
  "stevearc/dressing.nvim",
  "mg979/vim-visual-multi",
  {
    "szw/vim-maximizer",
    keys = {
      {
        "<leader>wm",
        "<cmd>MaximizerToggle<CR>",
        desc = "Maximize/minimize a split",
      },
    },
  },
  create_import("gitsigns"),
  create_import("toggleterm"),
  create_import("tokyonight"),
  create_import("which-key"),
  create_import("flash"),
  create_import("treesitter"),
  create_import("telescope"),
  create_import("mini"), -- collection of stuff
  create_import("lualine"),
  create_import("bufferline"),
  create_import("nvim-tree"),
  create_import("dashboard"),
  create_import("persistence"),
  create_import("lspconfig"), -- dir of stuff
  create_import("todo-comments"),
  create_import("trouble"),
  -- TODO: dap
})
