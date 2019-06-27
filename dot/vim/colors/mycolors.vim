" vim: ts=4 sw=4 et

set background=dark
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="mycolors"

hi erlangAtom      ctermfg=Red  cterm=bold

hi Normal          ctermfg=LightGrey  ctermbg=Black
hi Function        ctermfg=Yellow
hi String          ctermfg=Red
hi Comment         ctermfg=Magenta
hi Type            ctermfg=Green
hi Boolean         ctermfg=Cyan
hi Number          ctermfg=Red  cterm=bold
hi link Float      Number
hi Identifier      ctermfg=Green
hi Operator        ctermfg=Green
hi Keyword         ctermfg=Cyan
hi Macro           ctermfg=Green
hi Constant        ctermfg=Green
hi Tag             ctermfg=LightMagenta  cterm=bold
hi Conditional     ctermfg=Cyan
hi Statement       ctermfg=Yellow
hi Repeat          ctermfg=Cyan
hi Delimiter       ctermfg=Blue
hi Special         ctermfg=LightGrey

hi StatusLine      ctermfg=236
hi StatusLineNC    ctermfg=236
hi VertSplit       ctermfg=236
hi SignColumn      ctermbg=234
hi LineNr          ctermfg=242

hi NonText         ctermfg=65
hi SpecialKey      ctermfg=65

hi link shShellVariables    Identifier
hi link shLoop              Repeat
hi shRedir                  ctermfg=Yellow
hi link shTestOpr           Statement
hi link shRepeat            Normal
hi link shQuote             String

hi diffAdded       ctermfg=Green cterm=bold
hi diffChanged     ctermfg=Blue cterm=bold
hi diffRemoved     ctermfg=Red cterm=bold

hi ALEError        ctermfg=16 ctermbg=Red
hi ALEWarning      ctermfg=16 ctermbg=Yellow
hi ALEInfo         ctermfg=16 ctermbg=Blue
hi ALEStyleError   ctermfg=16 ctermbg=Red
hi ALEStyleWarning ctermfg=16 ctermbg=Yellow
