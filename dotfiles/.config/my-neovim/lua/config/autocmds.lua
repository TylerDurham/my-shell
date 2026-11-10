
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
--
-- Floating windows (Mason, Lazy, LSP hover, :checkhealth, …) link to
-- NormalFloat, so they keep a solid background — otherwise they're unreadable
-- over the buffer behind them. It comes from the theme's float bg, falling
-- back to its Normal bg, and is captured before Normal is cleared.
local function clear_bg()
  local function get(group)
    return vim.api.nvim_get_hl(0, { name = group, link = false })
  end
  local function set_bg(group, bg)
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", get(group), { bg = bg }))
  end

  local float_bg = get("NormalFloat").bg or get("Normal").bg

  for _, group in ipairs({
    "Normal", "NormalNC", "SignColumn",
    "EndOfBuffer", "LineNr", "FoldColumn", "MsgArea",
    "NeoTreeNormal", "NeoTreeNormalNC", "TelescopeNormal", "TelescopeBorder",
  }) do
    set_bg(group, "NONE")
  end

  -- Border and title share the float bg so the box reads as one solid panel.
  for _, group in ipairs({ "NormalFloat", "FloatBorder", "FloatTitle" }) do
    set_bg(group, float_bg or "NONE")
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("Transparent", { clear = true }),
  callback = clear_bg,
})
clear_bg() -- the saved theme loads before this file runs, so apply once now
