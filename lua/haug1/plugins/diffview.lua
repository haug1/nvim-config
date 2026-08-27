return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
    "DiffviewRefresh",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: working tree vs HEAD" },
    { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diffview: vs previous commit" },
    { "<leader>gm", "<cmd>DiffviewOpen origin/HEAD...HEAD<CR>", desc = "Diffview: vs merge base" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview: repo history" },
    { "<leader>gf", "<cmd>DiffviewFileHistory --follow %<CR>", desc = "Diffview: current file history" },
    { "<leader>gf", "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = "v", desc = "Diffview: selection history" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview: close" },
    { "<leader>gt", "<cmd>DiffviewToggleFiles<CR>", desc = "Diffview: toggle file panel" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
      },
    },
    file_panel = {
      listing_style = "tree",
      win_config = { width = 32 },
    },
    keymaps = {
      view = {
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        { "n", "<leader>hd", "]c", { desc = "Next hunk" } },
        { "n", "<leader>hu", "[c", { desc = "Prev hunk" } },
      },
      file_panel = {
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
      },
    },
  },
}
