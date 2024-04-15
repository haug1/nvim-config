return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local blame = function()
          gs.blame_line({ full = true })
        end

        map("n", "<leader>hd", gs.next_hunk, "Next hunk")
        map("n", "<leader>hu", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hb", blame, "Blame line")
        map("n", "<leader>hP", gs.diffthis, "Diff this")
      end,
    },
  },
}
