return {
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-q>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
