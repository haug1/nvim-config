vim.cmd([[autocmd BufNewFile,BufRead *.conf setfiletype conf]])
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local highlights = {
      "Normal",
      "NormalNC",
      "LineNr",
      "Folded",
      "NonText",
      "SpecialKey",
      "VertSplit",
      "SignColumn",
      "EndOfBuffer",
    }
    for _, name in pairs(highlights) do
      vim.cmd.highlight(name .. " guibg=none ctermbg=none")
    end
  end,
})
