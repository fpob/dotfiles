" Settings -----------------------------------------------------------------{{{1

set nocompatible

" Historie, zálohy
set backup
set backupdir=~/.vim/tmp,/tmp
set directory=~/.vim/tmp,/tmp
set history=50
set viewoptions-=options

" Undo configuration
set undolevels=100
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo,/tmp
endif

" Odsazování
set backspace=indent,eol,start  " backspace maže vše
set expandtab                   " tab na mezery
set copyindent
set preserveindent
set shiftwidth=4                " odsování
set tabstop=4
set smarttab                    " inteligetní tab
set smartindent                 " inteligetní odsazení
set autoindent
set formatoptions=cqlron

" Foldy
set foldmethod=marker
set foldcolumn=2    " sloupec skladů
set foldnestmax=3   " maximální zanoření foldů

" UI
set notitle         " nepřepisovat nadpis terminálu
set showcmd
set showmatch       " zvýraznění protější závorky při psaní
set lazyredraw      " nepřekreslovat u maker, reg. ...
set number
set ruler
set list            " zobrazování bilých zn.
set listchars=tab:›\ ,nbsp:~
set scrolloff=5     " 5ř při posunování
set sidescrolloff=5 " 5zn pri posunování
set cursorline
set autoread        " automaticky načíst pokud se soubor změní
set confirm         " místo selhání :q/:e se zeptá
set noshowmode      " nezobrazovat mod (insert, normal, ... resi airline)
set laststatus=2
set virtualedit=block

" Splits
set splitright
set splitbelow

if has('conceal')
    set conceallevel=0
    set concealcursor=n
endif

" Wild menu
set wildchar=<Tab>  " autocompl ex příkazů
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*~,*.pyc,__pycache__/,.git/,.tox/,.venv/

" Nevydávát otravné zvuky!
if v:version >= 800
    set belloff=all
endif
set noerrorbells
set novisualbell

" Povolení myši
if has('mouse')
    set mouse=a
endif

" Zalamování řádků
set textwidth=80
set colorcolumn=+1,+9  " Zvýraznění &textwidth+1/+9 sloupce
set wrap
set linebreak       " zalamovani za 'breakat', ne za poslednim znakem
set breakindent     " Wrap s odsazováním
set showbreak=↳     " znak na začátku zalomeného řádku
set nojoinspaces    " při spojování ř.(S-j) nedává 2 mezery za větu

" Vyhledávání
set ignorecase  " ignorovat velikost písmena při hledání
set smartcase
set incsearch
set hlsearch    " zvýraznit nalezená slova
nohlsearch      " nezvýraznovat po reloadu vimu

" Diff
set diffopt=filler,vertical

" Formáty souborů
set fileformats=unix,dos,mac
set fileencodings=utf-8,iso-8859-2

" Barvy
set t_Co=256
set background=dark

" Jazyk oprav
set spelllang=cs,en

if !has('nvim')
    set cryptmethod=blowfish2
endif

if has('unnamedplus')
    set clipboard=unnamedplus
endif

if has('gui_running')
    " Nadpis okna
    set title titlestring=Vim:\ %f\ %r%m

    " výchozí velikost okna
    set lines=40 columns=100

    set guioptions=acgit
    set guifont=Hack\ 9
endif

" Vlastní dokumentace, pokud adresář existuje
if isdirectory($HOME . "/.vim/doc")
    helptags $HOME/.vim/doc
endif

" Syntax
syntax enable
syntax on
filetype plugin indent on

" Varables -----------------------------------------------------------------{{{1

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

let g:user = Chomp(system('id -un'))

if getenv('GIT_AUTHOR_NAME') != v:null
    let g:user_name = getenv('GIT_AUTHOR_NAME')
else
    let g:user_name = Chomp(system('git config --includes --get user.name 2>/dev/null'))
endif

if getenv('GIT_AUTHOR_EMAIL') != v:null
    let g:user_email = getenv('GIT_AUTHOR_EMAIL')
else
    let g:user_email = Chomp(system('git config --includes --get user.email 2>/dev/null'))
endif

" Colors -------------------------------------------------------------------{{{1

" Tweak colors
autocmd ColorScheme * runtime after/colors.vim

silent! colorscheme molokai     " Barevné schéma

" Highlight groups for use in `:match`
highlight R ctermbg=darkred guibg=darkred
highlight G ctermbg=darkgreen guibg=darkgreen
highlight B ctermbg=darkblue guibg=darkblue

" Autocommands -------------------------------------------------------------{{{1

" Definovat a resetovat autocmdgroup vimrc
augroup vimrc
    autocmd!

    " Automatické uložení a načtení viewů (foldy, pozice kurzoru, ...)
    autocmd BufLeave,VimLeave *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|    mkview
        \|  endif
    autocmd BufRead *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|    silent! loadview
        \|  endif

    " Show colorcolumn as +1,+10%
    autocmd BufReadPost,OptionSet textwidth
        \ exec 'set colorcolumn=+1,+' . (float2nr(round(&textwidth * 0.1)) + 1)
augroup END

" Mappings -----------------------------------------------------------------{{{1

let mapleader = ","
let maplocalleader=","

" Movement
noremap <MouseDown> 3<C-Y>
noremap <MouseUp> 3<C-E>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Move by visual lines not by file lines
nnoremap <silent> k gk
nnoremap <silent> j gj

" Keep selection when indenting/outdenting
vnoremap < <gv
vnoremap > >gv

" Add new line...
inoremap <S-Cr> <Esc>o
nnoremap <S-Cr> o<Esc>

" Yank to the end
nnoremap Y y$

" Tab switching
nnoremap <Left> gT
nnoremap <Right> gt
nnoremap <C-h> gT
nnoremap <C-l> gt

" Buffer switching
nnoremap <Up> :bp<Cr>
nnoremap <Down> :bn<Cr>
nnoremap <C-k> :bp<Cr>
nnoremap <C-j> :bn<Cr>

" Window switching (alt)
nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l
nnoremap <M-k> <C-w>k
nnoremap <M-j> <C-w>j

" Fold with spacebar
nnoremap <Space> za
vnoremap <Space> zf

" Disable help
nnoremap <F1> <nop>

" Faster saving and closing
nnoremap <F2> :w<Cr>
nnoremap <F3> :x<Cr>
nnoremap <F4> :q<Cr>
nnoremap <S-F2> :wa<Cr>
nnoremap <S-F3> :xa<Cr>
nnoremap <S-F4> :qa<Cr>

nnoremap <F5> :nohlsearch<Cr>
" <F7>, <F8> mapped by plugins
nnoremap <F9> :make<Cr>
nnoremap <F10> :make run<Cr>

" Insert the word/WORD under the cursor
cnoremap <Leader>w <C-r><C-w>
cnoremap <Leader>W <C-r><C-a>
" Insert the line under the cursor
cnoremap <Leader>l <C-r><C-l>

" Insert word regex (/\<word\>/) for the word under the cursor
cnoremap <Leader>rw /\<<C-r><C-w>\>/

" Word to uppercase
inoremap <C-u> <esc>viwUea

" Typografie
inoremap <Leader><Leader>, „
inoremap <Leader><Leader>' “
inoremap <Leader><Leader>" “
inoremap <Leader><Leader>- –
inoremap <Leader><Leader>. …

" Yank directory
nnoremap <silent> yd :let @+=expand("%:p:h")<Cr>
" Yank full path
nnoremap <silent> yp :let @+=expand("%:p")<Cr>
" Yank file name
nnoremap <silent> yn :let @+=expand("%:t")<Cr>

" Close preview window
nnoremap <Leader>z <C-W>z

" Load packages configuration ----------------------------------------------{{{1

runtime! pack/*/init.vim
