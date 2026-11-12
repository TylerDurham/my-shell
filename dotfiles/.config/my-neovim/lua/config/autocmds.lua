
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

-- Dim text (comments, line numbers, inlay hints) is tuned for the theme's own
-- bg and loses contrast over the terminal's. Blend each fg toward white.
local BRIGHTEN = 0.25 -- 0 = theme as-is, 1 = pure white

local function brighten_dim_text()
  local function lighten(c)
    local r, g, b = bit.rshift(c, 16), bit.band(bit.rshift(c, 8), 0xff), bit.band(c, 0xff)
    local function up(x) return math.floor(x + (255 - x) * BRIGHTEN + 0.5) end
    return bit.bor(bit.lshift(up(r), 16), bit.lshift(up(g), 8), up(b))
  end

  -- Resolve every group first: @comment usually links to Comment, and reading
  -- it after Comment is changed would brighten it twice.
  local updates = {}
  for _, group in ipairs({
    "Comment", "@comment",
    "LineNr", "LineNrAbove", "LineNrBelow",  -- relativenumber uses Above/Below
    "LspInlayHint", "LspCodeLens",
    "DiagnosticUnnecessary",                 -- unused vars/imports
    "NonText", "FoldColumn", "WinSeparator",
    "BlinkCmpGhostText", "GitSignsCurrentLineBlame",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl.fg then
      updates[group] = vim.tbl_extend("force", hl, { fg = lighten(hl.fg) })
    end
  end
  for group, hl in pairs(updates) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

local function apply_transparency()
  clear_bg()
  brighten_dim_text()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("Transparent", { clear = true }),
  callback = apply_transparency,
})
apply_transparency() -- the saved theme loads before this file runs, so apply once now
