
local lush = require('lush')
local hsl = lush.hsl

local palette = {
  bg       = hsl("#{{ color2.hex }}"),   -- Background
  fg       = hsl("#{{ color1.hex }}"),   -- Foreground
  cursor   = hsl("#{{ color1.hex }}"),   -- Cursor
  red      = hsl("#{{ color3.hex }}"),   -- Errors, warnings
  green    = hsl("#{{ color4.hex }}"),   -- Strings, success messages
  yellow   = hsl("#{{ color5.hex }}"),   -- Constants, booleans
  blue     = hsl("#{{ color6.hex }}"),   -- Keywords, function names
  magenta  = hsl("#{{ color7.hex }}"),   -- Special identifiers, types
  cyan     = hsl("#{{ color8.hex }}"),   -- Comments, secondary info
  white    = hsl("#{{ color3.hex }}"),  -- Default text
  bright_red     = hsl("#{{ color11.hex }}"),
  bright_green   = hsl("#{{ color12.hex }}"),
  bright_yellow  = hsl("#{{ color13.hex }}"),
  bright_blue    = hsl("#{{ color14.hex }}"),
  bright_magenta = hsl("#{{ color15.hex }}"),
  bright_cyan    = hsl("#{{ color16.hex }}"),
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
