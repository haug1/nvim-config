return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-sleuth",
  { "numToStr/Comment.nvim", opts = {} },
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
}
