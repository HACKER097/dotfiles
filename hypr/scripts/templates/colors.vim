
" Special
let background = "#{{ color2.hex }}"  " darkest
let foreground = "#{{ color1.hex }}"  " lightest
let cursor     = "#{{ color3.hex }}"  " readable but distinct

" ANSI Colors
let color0  = "#{{ color2.hex }}"   " black (bg)
let color1  = "#{{ color1.hex }}"   " red (bright for keywords)
let color2  = "#{{ color3.hex }}"   " green (strings, numbers)
let color3  = "#{{ color4.hex }}"   " yellow (constants, booleans)
let color4  = "#{{ color5.hex }}"   " blue (function names)
let color5  = "#{{ color6.hex }}"   " magenta (variable names)
let color6  = "#{{ color12.hex }}"   " cyan (comments)
let color7  = "#{{ color1.hex }}"   " white (default text)

" Bright ANSI Colors (fallbacks or UI)
let color8  = "#{{ color12.hex }}"   " bright black (dimmed text)
let color9  = "#{{ color3.hex }}"   " bright red
let color10 = "#{{ color4.hex }}"   " bright green
let color11 = "#{{ color5.hex }}"   " bright yellow
let color12 = "#{{ color6.hex }}"   " bright blue
let color13 = "#{{ color7.hex }}"   " bright magenta
let color14 = "#{{ color8.hex }}"  " bright cyan
let color15 = "#{{ color1.hex }}"   " bright white (foreground fallback)
