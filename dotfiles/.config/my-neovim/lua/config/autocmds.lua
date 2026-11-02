
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "CustomYank",
      timeout = 300,
    })
  end,
})


local colors = require("lib.colors")
-- Usage:
local yank = colors.get_color("Keyword", "fg")

vim.api.nvim_set_hl(0, "CustomYank", { bg = yank, fg = "#000000" }) -- Soft banana yellow

-- Transparency: drop background colors so the terminal's translucent, blurred
-- background shows through. Theme-agnostic, so it survives :ThemeSelect.
local function clear_bg()
  for _, group in ipairs({
    "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn",
    "EndOfBuffer", "LineNr", "FoldColumn", "MsgArea",
    "NeoTreeNormal", "NeoTreeNormalNC", "TelescopeNormal", "TelescopeBorder",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "NONE" }))
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("Transparent", { clear = true }),
  callback = clear_bg,
})
clear_bg() -- the saved theme loads before this file runs, so apply once now
