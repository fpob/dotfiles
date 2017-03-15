if &filetype == 'c'
    " Linux Coding
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal softtabstop=8
    setlocal noexpandtab
else
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal expandtab
endif

setlocal textwidth=80
setlocal cindent
setlocal formatoptions=tcqlron
setlocal cinoptions=:0,l1,t0,g0,(0
