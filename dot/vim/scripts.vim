
if did_filetype()
	finish
endif

" Lint Python 2 scripts with 'python2 -m flake8' instead of 'python3 -m flake8'
if getline(1) =~ '^#!.*\<python2\>'
	let g:ale_python_flake8_executable = 'python2'
endif
