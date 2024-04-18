local do_auto_format = true

return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>uf",
      function()
        do_auto_format = not do_auto_format
        print("Auto-formatting:", do_auto_format)
      end,
      mode = "",
      desc = "Toggle auto-formatting",
    },
    {
      "<leader>fb",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat [B]uffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if not do_auto_format then
        return
      end

      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
  },
}
