return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- TODO: Disable buffernext/previous navigation in terminal mode
      require("haug1.config.toggleterm")
    end,
  },
}
