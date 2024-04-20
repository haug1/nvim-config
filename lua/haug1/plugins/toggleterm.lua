return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      persist_mode = false,
      start_in_insert = false,
      on_open = function()
        -- workaround: always insert mode when terminal opened
        vim.fn.timer_start(1, function()
          vim.cmd("startinsert!")
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
