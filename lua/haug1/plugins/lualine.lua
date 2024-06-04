return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status") -- to configure lazy pending updates count
      lualine.setup({
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            {
              "buffers",
              -- cond = function()
              --   local buffers = require("haug1.config.buffers").get_buffers()
              --   return #buffers > 1
              -- end,
              symbols = { modified = " ●" },
            },
          },
          lualine_x = {
            {
              lazy_status.updates,
              cond = lazy_status.has_updates,
              color = { fg = "#ff9e64" },
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
        },
      })
    end,
  },
}
