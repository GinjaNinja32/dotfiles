let g:status#detail_width = 100 " Full detail threshold.
let g:status#abbrev_width = 79 " Path abbreviation threshold.
let g:status#basic_width = 70 " Minimal detail threshold.
let g:status#min_width = 50 " Bare essentials threshold.

function! status#aleE() abort
	let l:counts = ale#statusline#Count(bufnr(''))

	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:all_errors > 0
		\ ? printf('%d', l:all_errors)
		\ : ''
endfunction

function! status#aleW() abort
	let l:counts = ale#statusline#Count(bufnr(''))

	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:all_non_errors > 0
		\ ? printf('%d', l:all_non_errors)
		\ : ''
endfunction

function! s:is_filelike() abort
  return &buftype ==# '' || &buftype =~# '^nowrite\|acwrite$'
endfunction

function! s:has_filename() abort
  return &buftype ==# '' || &buftype ==# 'help'
endfunction

function! status#filename() abort
  if !s:has_filename()
    return ''
  endif

  let l:filename = (&buftype ==# 'help'
    \ ? expand('%:t')
    \ : expand('%:~:.'))
  if winwidth(0) < g:status#abbrev_width
    let l:filename = pathshorten(l:filename)
  endif

  return empty(l:filename) ? '[No Name]' : l:filename
endfunction

function! status#fileinfo() abort
  let l:readonly = (&readonly ? '!' : '')
  let l:nomodifiable = (!&modifiable ? '#' : '')
  let l:modified = (&modified ? '+' : '')

  if s:is_filelike()
    return status#filename() . " " . l:readonly .  l:nomodifiable . l:modified
  else
    return status#filename()
  endif
endfunction
