return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    enabled = false,
    config = function()
      -- vim.cmd.hi 'Comment gui=none'
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        on_highlights = function(hl)
          hl.FlashLabel = {
            bg = "#ffffff",
            bold = true,
            fg = "#000000",
          }
          hl.Comment = {
            fg = "#008000",
          }
        end,
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
