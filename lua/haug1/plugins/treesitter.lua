return {
  {
    -- tree-sitter CLI: required by nvim-treesitter `main` to build parsers
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tree-sitter-cli" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
      })
      local move = require("nvim-treesitter-textobjects.move")
      local function map(lhs, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          fn(query, "textobjects")
        end, { desc = desc })
      end
      -- next start
      map("<leader>Nf", move.goto_next_start, "@function.inner", "Next function")
      map("<leader>Nc", move.goto_next_start, "@class.inner", "Next class")
      map("<leader>Na", move.goto_next_start, "@parameter.inner", "Next parameter")
      -- next end
      map("<leader>nf", move.goto_next_end, "@function.inner", "Next function end")
      map("<leader>nc", move.goto_next_end, "@class.inner", "Next class end")
      map("<leader>na", move.goto_next_end, "@parameter.inner", "Next parameter end")
      -- previous start
      map("<leader>pf", move.goto_previous_start, "@function.inner", "Prev function")
      map("<leader>pc", move.goto_previous_start, "@class.inner", "Prev class")
      map("<leader>pa", move.goto_previous_start, "@parameter.inner", "Prev parameter")
      -- previous end
      map("<leader>Pf", move.goto_previous_end, "@function.inner", "Prev function end")
      map("<leader>Pc", move.goto_previous_end, "@class.inner", "Prev class end")
      map("<leader>Pa", move.goto_previous_end, "@parameter.inner", "Prev parameter end")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "jsdoc",
        "json",
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
    },
    config = function(_, opts)
      -- jsonc shares the json grammar (main has no separate jsonc parser)
      vim.treesitter.language.register("json", "jsonc")

      require("nvim-treesitter").install(opts.ensure_installed)

      -- incremental selection (main dropped the built-in module)
      require("haug1.config.treesitter_incremental").setup()

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Treesitter: start highlight + indent (auto-install parsers)",
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end
          -- parser not present yet: auto-install if the CLI offers it, then
          -- bail (install is async; the buffer highlights on next open)
          if not vim.treesitter.language.add(lang) then
            local ok, available =
              pcall(require("nvim-treesitter").get_available)
            if ok and vim.tbl_contains(available, lang) then
              require("nvim-treesitter").install(lang)
            end
            return
          end
          vim.treesitter.start(args.buf, lang)
          vim.bo[args.buf].indentexpr =
            "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
