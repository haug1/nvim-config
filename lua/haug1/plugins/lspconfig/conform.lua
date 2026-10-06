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
    -- Surface missing/broken formatter executables instead of failing silently.
    notify_on_error = true,
    format_on_save = function()
      if not do_auto_format then
        return
      end

      return {
        timeout_ms = 2000,
        -- Save formatting should use only explicitly configured formatters.
        -- LSP formatting remains available through the manual format mapping.
        lsp_fallback = false,
      }
    end,
  },
}
