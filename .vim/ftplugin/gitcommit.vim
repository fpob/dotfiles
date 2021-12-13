augroup ftplugin_gitcommit
    autocmd!
    " Always start git commit at first line and with opened all folds
    autocmd VimEnter * call setpos(".", [0, 1, 1, 0]) | silent! %foldopen
augroup END

setlocal foldmethod=syntax

" Enable spell checking in commits
setlocal spell
