" Vim script to tweak colors, executed after loading color scheme.

" Underline spell errors in terminal
hi SpellBad cterm=underline
hi SpellCap cterm=underline

" GitGutter signs
hi GitGutterAdd ctermfg=2 guifg=#00cc00
hi GitGutterChange ctermfg=3 guifg=#cccc00
hi GitGutterDelete ctermfg=1 guifg=#cc0000

if g:colors_name ==? 'molokai'
    hi CursorLine ctermbg=234 guibg=#242828
    hi CursorColumn ctermbg=234 guibg=#242828

    " Better diff highlighting
    hi DiffAdd guibg=#003300 gui=none
    hi DiffChange guibg=#333300 gui=none
    hi DiffText guibg=#4C4745 gui=bold,italic
    hi DiffDelete guibg=#440000 gui=none

    " GitGutter signs
    hi GitGutterAdd ctermfg=2 ctermbg=236 guifg=#00cc00 guibg=#232526
    hi GitGutterChange ctermfg=3 ctermbg=236 guifg=#cccc00 guibg=#232526
    hi GitGutterDelete ctermfg=1 ctermbg=236 guifg=#cc0000 guibg=#232526
endif
