return {
  { -- Linting
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = { linters_by_ft = {} },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      local ktlint_default_editorconfig = vim.fn.stdpath("config")
        .. "/lua/haug1/config/ktlint/defaults.editorconfig"
      if lint.linters.ktlint then
        lint.linters.ktlint.args = function()
          local filename = vim.api.nvim_buf_get_name(0)
          return {
            "--reporter=json",
            "--editorconfig=" .. ktlint_default_editorconfig,
            "--stdin",
            "--stdin-path=" .. filename,
          }
        end
      end

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost", "InsertLeave" },
        {
          group = lint_augroup,
          callback = function()
            require("lint").try_lint()
          end,
        }
      )

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}
