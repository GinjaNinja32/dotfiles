
let s:orange = [ '#ff5500', 202 ]
let s:red = [ '#ff0000', 196 ]

let s:black = [ '#000000', 16 ]
let s:grey1 = [ '#1c1c1c', 234]
let s:grey2 = [ '#444444', 238 ]
let s:white = [ '#ffffff', 255 ]

let s:normal = [ '#00d7ff', 45 ]
let s:insert = [ '#ffff00', 226 ]
let s:replace = [ '#ff8700', 208 ]
let s:visual = [ '#ff5f00', 82 ]
let s:inactive = [ '#9e9e9e', 247 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:black, s:normal, 'bold' ], [ s:normal, s:grey1 ] ]
let s:p.normal.right = [ [ s:black, s:normal ], [ s:black, s:normal ], [ s:white, s:grey2 ] ]
let s:p.normal.middle = [ [ s:normal, s:grey1 ] ]
let s:p.normal.error = [ [ s:black, s:red ] ]
let s:p.normal.warning = [ [ s:black, s:orange, 'bold' ] ]

let s:p.inactive.right = [ [ s:black, s:inactive, 'bold' ], [ s:inactive, s:grey1 ] ]
let s:p.inactive.left =  [ [ s:black, s:inactive, 'bold' ], [ s:inactive, s:grey1 ] ]
let s:p.inactive.middle = [ [ s:black, s:grey1 ] ]

let s:p.insert.left = [ [ s:black, s:insert, 'bold' ], [ s:insert, s:grey1 ] ]

let s:p.replace.left = [ [ s:black, s:replace, 'bold' ], [ s:replace, s:grey1 ] ]

let s:p.visual.left = [ [ s:black, s:visual, 'bold' ], [ s:visual, s:grey1 ] ]

let s:p.tabline.left = [ [ s:normal, s:grey2 ] ]
let s:p.tabline.tabsel = [ [ s:black, s:normal ] ]
let s:p.tabline.middle = [ [ s:normal, s:grey1 ] ]
let s:p.tabline.right = [ [ s:normal, s:grey2 ] ]

let g:lightline#colorscheme#theme#palette = lightline#colorscheme#flatten(s:p)
