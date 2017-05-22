autocmd BufRead,BufNewFile *.html
    \ if glob('manage.py') ==# 'manage.py' | setlocal filetype=htmldjango | endif
