setlocal cindent
setlocal cinkeys-=0#
setlocal indentkeys-=0#

nnoremap <buffer> gd :YcmCompleter GoTo<Cr>
nnoremap <buffer> K :YcmCompleter GetDoc<Cr>
