set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif
let g:colors_name="mycolors"

hi Normal       ctermfg=LightGrey  ctermbg=Black
hi Function     ctermfg=Yellow
hi String       ctermfg=Red
hi Comment      ctermfg=Magenta
hi Type         ctermfg=Green
hi Boolean      ctermfg=Cyan
hi Number       ctermfg=Red  cterm=bold
hi link Float Number
hi Identifier   ctermfg=Green
hi Operator     ctermfg=Green
hi Keyword      ctermfg=Cyan
hi Macro        ctermfg=Green
hi Constant     ctermfg=Green
hi Tag          ctermfg=LightMagenta  cterm=bold
hi Conditional  ctermfg=Cyan
hi Statement    ctermfg=Yellow
hi Repeat       ctermfg=Cyan
hi Delimiter    ctermfg=Blue
hi Special      ctermfg=LightGrey

hi StatusLine   ctermfg=236
hi StatusLineNC ctermfg=236
hi VertSplit    ctermfg=236
hi SignColumn   ctermbg=234
hi LineNr       ctermfg=242

hi diffAdded    ctermfg=Green cterm=bold
hi diffChanged  ctermfg=Blue  cterm=bold
hi diffRemoved  ctermfg=Red   cterm=bold
