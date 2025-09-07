
local lush = require('lush')
local hsl = lush.hsl

local palette = {
  bg       = hsl("#0e0117"),   -- Background
  fg       = hsl("#e5b694"),   -- Foreground
  cursor   = hsl("#e5b694"),   -- Cursor
  red      = hsl("#db9c8c"),   -- Errors, warnings
  green    = hsl("#dd997a"),   -- Strings, success messages
  yellow   = hsl("#d1827a"),   -- Constants, booleans
  blue     = hsl("#cb6f76"),   -- Keywords, function names
  magenta  = hsl("#c85572"),   -- Special identifiers, types
  cyan     = hsl("#d0455c"),   -- Comments, secondary info
  white    = hsl("#db9c8c"),  -- Default text
  bright_red     = hsl("#ad2959"),
  bright_green   = hsl("#954162"),
  bright_yellow  = hsl("#7d204e"),
  bright_blue    = hsl("#5c1e4f"),
  bright_magenta = hsl("#620938"),
  bright_cyan    = hsl("#481736"),
}


return lush(function()
  return {
    Normal       { fg = palette.fg, bg = palette.bg },
    Cursor       { fg = palette.bg, bg = palette.cursor },
    Comment      { fg = palette.bright_cyan, gui = "italic" },
    Constant     { fg = palette.green },
    String       { fg = palette.blue },
    Identifier   { fg = palette.magenta },
    Function     { fg = palette.yellow },
    Statement    { fg = palette.red },
    Keyword      { fg = palette.red },
    Type         { fg = palette.magenta },
    Special      { fg = palette.blue },
    Underlined   { fg = palette.bright_blue, gui = "underline" },
    Error        { fg = palette.bright_red, bg = palette.bg, gui = "bold" },
    Todo         { fg = palette.bright_yellow, bg = palette.bg, gui = "bold" },
    LineNr       { fg = palette.cyan },
    CursorLineNr { fg = palette.yellow, gui = "bold" },
    Visual       { bg = palette.bright_blue },
    Pmenu        { fg = palette.fg, bg = palette.bright_cyan },
    PmenuSel     { fg = palette.bg, bg = palette.bright_yellow },
    StatusLine   { fg = palette.fg, bg = palette.bright_magenta },
    StatusLineNC { fg = palette.fg, bg = palette.bg },
  }
end)
