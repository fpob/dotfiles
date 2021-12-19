function! s:MakeViewCheck()
    if &filetype == 'gitcommit'
        return 0
    endif
    " Diff mode
    if &diff
        return 0
    endif
    " Buffer is marked as not a file
    if has('quickfix') && &buftype =~ 'nofile'
        return 0
    endif
    " File does not exist on disk
    if empty(glob(fnameescape(expand('%:p'))))
        return 0
    endif
    " We're in a temp dir
    if len($TEMP) && expand('%:p:h') == $TEMP
        return 0
    endif
    " Also in temp dir
    if len($TMP) && expand('%:p:h') == $TMP
        return 0
    endif

    return 1
endfunction

augroup autoview
    autocmd!
    " Autosave & Load views
    autocmd BufWritePost,BufLeave,WinLeave ?*
        \ if <SID>MakeViewCheck() | silent! mkview | endif
    autocmd BufWinEnter ?*
        \ if <SID>MakeViewCheck() | silent! loadview | endif
augroup END
