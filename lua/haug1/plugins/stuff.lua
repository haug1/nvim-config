return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-sleuth",
  -- commenting (gc/gcc) is built into Neovim 0.10+
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
