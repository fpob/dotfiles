" nekontrolovat pravopis v komentářích
let g:tex_comment_nospell = 1

" automaticke zalamovani radku a zvyrazneni sloupce
setlocal formatoptions+=t
setlocal textwidth=80

setlocal spell              " kontrola pravopisu
setlocal tabstop=2
setlocal shiftwidth=2
setlocal nolist

imap <buffer> <Char-0xA0> ~
imap <buffer> <S-Space> ~

function! TexCompile()
    if filereadable('Makefile') || filereadable('makefile') || filereadable('GNUmakefile')
        execute 'make!'
    else
        execute 'VimtexCompileSS'
    endif
endfun
command! TexCompile call TexCompile()

nnoremap <buffer> <F7> :VimtexTocToggle<Cr>
nnoremap <buffer> <F9> :TexCompile<Cr>
nnoremap <buffer> <F10> :VimtexView<Cr>
