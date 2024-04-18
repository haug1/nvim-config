return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "jsdoc",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "go",
        "kotlin",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["<leader>Nf"] = "@function.inner",
            ["<leader>Nc"] = "@class.inner",
            ["<leader>Na"] = "@parameter.inner",
          },
          goto_next_end = {
            ["<leader>nf"] = "@function.inner",
            ["<leader>nc"] = "@class.inner",
            ["<leader>na"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["<leader>pf"] = "@function.inner",
            ["<leader>pc"] = "@class.inner",
            ["<leader>pa"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["<leader>Pf"] = "@function.inner",
            ["<leader>Pc"] = "@class.inner",
            ["<leader>Pa"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
