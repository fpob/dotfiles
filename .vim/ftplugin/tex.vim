" nekontrolovat pravopis v komentářích
let g:tex_comment_nospell = 1

setlocal colorcolumn=80
setlocal textwidth=80       " Automatické zalamování
setlocal nolinebreak        " Zalamování na hranicích slov
setlocal showbreak=         " Nijak neoznačovat vizuální zalomení řádku
setlocal formatoptions+=t
setlocal spell              " kontrola pravopisu
setlocal tabstop=2
setlocal shiftwidth=2
setlocal wrap
setlocal linebreak
setlocal nolist

inoremap <Char-0xA0> ~
imap <S-Space> ~

nnoremap <F7> :VimtexTocToggle<Cr>
"nnoremap <F9> :VimtexCompileSS<Cr>
nnoremap <F10> :VimtexView<Cr>
