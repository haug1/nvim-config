return {
  { -- Linting
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = { linters_by_ft = {} },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      local ktlint = require("haug1.config.ktlint")
      if lint.linters.ktlint then
        local cmd, jvm_args = ktlint.command("lint")
        lint.linters.ktlint.cmd = cmd
        lint.linters.ktlint.args = vim.list_extend(vim.deepcopy(jvm_args), {
          "--reporter=json",
          "--editorconfig=" .. ktlint.default_editorconfig,
          "--stdin",
          "--stdin-path",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        })
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
