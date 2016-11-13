set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif
let g:colors_name="ben"

hi Normal	ctermfg=LightGrey	ctermbg=Black
hi Function	ctermfg=Yellow
hi String	ctermfg=Red
hi Comment	ctermfg=Magenta
hi Type		ctermfg=Green
hi Boolean	ctermfg=Cyan
hi Number	ctermfg=Red		cterm=bold
hi link Float Number
hi Identifier	ctermfg=Green
hi Operator	ctermfg=Green
hi Keyword	ctermfg=Cyan
hi Macro	ctermfg=Green
hi Constant	ctermfg=Green
hi Tag		ctermfg=LightMagenta	cterm=bold
hi Conditional	ctermfg=Cyan
hi Statement	ctermfg=Yellow
hi Repeat	ctermfg=Cyan
hi Delimiter	ctermfg=Blue
hi Special	ctermfg=LightGrey
