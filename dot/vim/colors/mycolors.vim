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
hi Character       ctermfg=Red
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
hi Folded          ctermbg=236 ctermfg=none
hi FoldColumn      ctermbg=236 ctermfg=none

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

hi Error ctermfg=232 ctermbg=Red
" ctermfg=16 ctermbg=Red
hi Warn  ctermfg=232 ctermbg=Yellow
" ctermfg=16 ctermbg=Yellow
hi Todo  ctermfg=232 ctermbg=Blue
hi Info  ctermfg=232 ctermbg=Cyan
" ctermfg=16 ctermbg=Blue

hi link ALEError            Error
hi link ALEWarning          Warn
hi link ALEInfo             Info
hi link ALEStyleError       Error
hi link ALEStyleWarning     Warn
hi link goDiagnosticError   Error
hi link goDiagnosticWarning Warn
