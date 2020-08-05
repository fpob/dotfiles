" Settings -----------------------------------------------------------------{{{1

set nocompatible

" Backups
set backup
set backupdir=~/.vim/tmp,/tmp
set directory=~/.vim/tmp,/tmp

" History of ':' commands
set history=500

" Number of undo changes
set undolevels=1000
" Persist undo (can do undo after close and reopen)
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo,/tmp
endif

" Allow backspacing over ...
set backspace=indent,eol,start

" Indentation
set expandtab
set copyindent
set preserveindent
set shiftwidth=4
set tabstop=4
set smarttab
set smartindent
set autoindent

" Automatic formatting
set formatoptions=cqlron

" Folds
set foldmethod=marker
set foldcolumn=2
set foldnestmax=3

" UI
set notitle
set showcmd
set showmatch
set lazyredraw
set number
set ruler
set cursorline
set noshowmode      " handled by airline
set laststatus=2
set confirm

" Display some whitespace character
set list
set listchars=tab:›\ ,nbsp:~

" Minimal number of lines/columns to keep around cursor
set scrolloff=5
set sidescrolloff=5

" Autoread file when changed on disk
set autoread

" In block cursor can be positioned where there is no actual character
set virtualedit=block

" What bases are considered when using <C-a> and <C-x>
set nrformats=bin,hex

" Where to put splits
set splitright
set splitbelow

" Characters "hiding"
if has('conceal')
    set conceallevel=0
    set concealcursor=n
endif

" Wild menu (completion)
set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*~,*.pyc,__pycache__/,.git/,.tox/,.venv/

" No sound or visual bell
if v:version >= 800
    set belloff=all
endif
set noerrorbells
set novisualbell

" Enable mouse
if has('mouse')
    set mouse=a
endif

" Line width and highlight column
set textwidth=80
set colorcolumn=+1,+9
" Update colorcolumn to +1,+10% on texwidth change (needed because of %)
augroup vimrc_colorcolumn
    autocmd!
    autocmd BufReadPost,OptionSet textwidth
        \ exec 'set colorcolumn=+1,+' . (float2nr(round(&textwidth * 0.1)) + 1)
augroup END

" Line wrapping
set wrap
set linebreak
set breakindent
set showbreak=↳

" Don't insert two spaces after '.', '?' and '!' with <J>
set nojoinspaces

" Ignore case if all character are lowercase
set ignorecase
set smartcase
" Show where pattern matches while typing search
set incsearch
" Highlight search + clear on start
set hlsearch
nohlsearch

" Diff
set diffopt=filler,vertical

" Newline formats and encoding that will be tried when starting to edit existing
" file. For new files first item will be used.
set fileformats=unix,dos,mac
set fileencodings=utf-8,iso-8859-2

" Enable 256 colors on dark terminal.
set t_Co=256
set background=dark

" Spell + disable on start
set spelllang=cs,en

" Use "+" register for all y/d/c operations
if has('unnamedplus')
    set clipboard=unnamedplus
endif

if has('gui_running')
    " Window title
    set title titlestring=Vim:\ %f\ %r%m
    " Hide buttons, scroll, ...
    set guioptions=acgit
    " Font
    set guifont=Hack\ 9
endif

" Generate help tags, don't fail if directory does't exist
silent! helptags ~/.vim/doc

" Enable syntax
syntax enable
syntax on
" Enable filetype detection, plugins and indentation
filetype plugin indent on

" Varables -----------------------------------------------------------------{{{1

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

let g:user = Chomp(system('id -un'))
let g:user_name = Chomp(system('git config --includes --get user.name 2>/dev/null'))
let g:user_email = Chomp(system('git config --includes --get user.email 2>/dev/null'))

if $GIT_AUTHOR_NAME != ""
    let g:user_name = $GIT_AUTHOR_NAME
endif

if $GIT_AUTHOR_EMAIL != ""
    let g:user_email = $GIT_AUTHOR_EMAIL
endif

" Colors -------------------------------------------------------------------{{{1

" Tweak colors
augroup vimrc_colors
    autocmd!
    autocmd ColorScheme * runtime after/colors.vim
augroup END

silent! colorscheme molokai     " Barevné schéma

" Highlight groups for use in `:match`
highlight R ctermbg=darkred guibg=darkred
highlight G ctermbg=darkgreen guibg=darkgreen
highlight B ctermbg=darkblue guibg=darkblue

" Autoview -----------------------------------------------------------------{{{1

function! MakeViewCheck()
    if &filetype == 'gitcommit'
        return 0
    endif
    " Buffer is marked as not a file
    if has('quickfix') && &buftype =~ 'nofile'
        return 0
    endif
    " File does not exist on disk
    if empty(glob(expand('%:p')))
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

augroup vimrc_autoview
    autocmd!
    " Autosave & Load views
    autocmd BufWritePost,BufLeave,WinLeave ?*
        \ if MakeViewCheck() | silent! mkview | endif
    autocmd BufWinEnter ?*
        \ if MakeViewCheck() | silent! loadview | endif
augroup END

" Mappings -----------------------------------------------------------------{{{1

let mapleader = ","
let maplocalleader=","

" Movement in insert mode (alt)
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>

" Begin new line but do not wrap it
inoremap <C-j> <C-o>o

" Move by visual lines not by file lines
nnoremap <silent> k gk
nnoremap <silent> j gj

" Keep selection when indenting/outdenting
vnoremap < <gv
vnoremap > >gv

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

" Window moving (alt-shift)
nnoremap <M-S-h> <C-w>H
nnoremap <M-S-l> <C-w>L
nnoremap <M-S-k> <C-w>K
nnoremap <M-S-j> <C-w>J

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
cnoremap <Leader>rw \<<C-r><C-w>\>

" Word to uppercase
inoremap <C-u> <esc>viwUea

" Close preview window
nnoremap <Leader>z <C-W>z

" Load packages configuration ----------------------------------------------{{{1

runtime! pack/*/init.vim
