" Always start git commit at first line
autocmd VimEnter * call setpos(".", [0, 1, 1, 0])

setlocal foldmethod=syntax

" Enable spell checking in commits
set spell
