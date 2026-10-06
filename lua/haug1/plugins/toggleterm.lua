return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      persist_mode = false,
      start_in_insert = false,
      on_open = function(terminal)
        -- Opening can be followed immediately by another keymap/window action.
        -- Enter terminal mode only if this terminal is still the focused window.
        vim.schedule(function()
          if
            terminal.window
            and vim.api.nvim_win_is_valid(terminal.window)
            and terminal:is_open()
            and terminal:is_focused()
          then
            vim.cmd("startinsert!")
          end
        end)
      end,
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      require("haug1.config.toggleterm").default_keymaps()
    end,
  },
}
