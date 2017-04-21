scriptencoding utf-8

let g:airline#themes#theme#palette = {}

let s:C = 45
let s:H = '#00d7ff'
let g:airline#themes#theme#palette.normal = airline#themes#generate_color_map(['#000000', s:H, 16, s:C], ['#ffffff', '#444444', 255, 238], [s:H, '#1c1c1c', s:C, 234])
let g:airline#themes#theme#palette.normal_modified = {'airline_c': ['#ffffff', '#5f005f', 255, 53, '']}

let s:C = 226
let s:H = '#ffff00'
let g:airline#themes#theme#palette.insert = airline#themes#generate_color_map(['#000000', s:H, 16, s:C], ['#ffffff', '#444444', 255, 238], [s:H, '#1c1c1c', s:C, 234])
let g:airline#themes#theme#palette.insert_modified = {'airline_c': ['#ffffff', '#5f005f', 255, 53, '']}

let s:C = 208
let s:H = '#ff8700'
let g:airline#themes#theme#palette.replace = airline#themes#generate_color_map(['#000000', s:H, 16, s:C], ['#ffffff', '#444444', 255, 238], [s:H, '#1c1c1c', s:C, 234])
let g:airline#themes#theme#palette.replace_modified = {'airline_c': ['#ffffff', '#5f005f', 255, 53, '']}

let s:C = 82
let s:H = '#ff5f00'
let g:airline#themes#theme#palette.visual = airline#themes#generate_color_map(['#000000', s:H, 16, s:C], ['#ffffff', '#444444', 255, 238], [s:H, '#1c1c1c', s:C, 234])
let g:airline#themes#theme#palette.visual_modified = {'airline_c': ['#ffffff', '#5f005f', 255, 53, '']}

let s:C = 247
let s:H = '#9e9e9e'
let g:airline#themes#theme#palette.inactive = airline#themes#generate_color_map(['#000000', s:H, 16, s:C], ['#ffffff', '#444444', 255, 238], [s:H, '#1c1c1c', s:C, 234])
let g:airline#themes#theme#palette.inactive_modified = {'airline_c': ['#ffffff', '#5f005f', 255, 53, '']}

let g:airline#themes#theme#palette.accents = {'red': ['#ff0000', '', 160, '']}

if get(g:, 'loaded_ctrlp', 0)
	let s:C = 45
	let s:H = '#00d7ff'
	let g:airline#themes#theme#palette.ctrlp = airline#extensions#ctrlp#generate_color_map([s:H, '#1c1c1c', s:C, 234, ''], ['#ffffff', '#444444', 255, 238, ''], ['#000000', s:H, 16,  s:C, 'bold'])
endif

