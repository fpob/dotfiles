" Settings -----------------------------------------------------------------{{{1

set nocompatible

execute pathogen#infect()
execute pathogen#helptags()

" Historie, zálohy
set backup
set backupdir=~/.vim/tmp,.,/tmp
set directory=~/.vim/tmp,.,/tmp
set history=50
set undolevels=100
set viewoptions-=options

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
set formatoptions=tcqlron

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

if has('conceal')
    set conceallevel=0
    set concealcursor=n
endif

" Wild menu
set wildchar=<Tab>  " autocompl ex příkazů
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*~,*.pyc,__pycache__/,.git/

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
set textwidth=79
set colorcolumn=+1  " Zvýraznění &textwidth+1 sloupce
set wrap
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

" Vlastní dokumentace, pokud adresář existuje
if isdirectory($HOME . "/.vim/doc")
    helptags $HOME/.vim/doc
endif

" Syntax
syntax enable
syntax on
filetype plugin indent on

" GUI settings -------------------------------------------------------------{{{1

if has('gui_running')
    " Nadpis okna
    set title titlestring=Vim:\ %f\ %r%m

    " výchozí velikost okna
    set lines=40 columns=100

    set guioptions=acgit
    set guifont=Hack\ 9
endif

" ColorScheme --------------------------------------------------------------{{{1

autocmd ColorScheme molokai
    \   hi CursorLine ctermbg=234 guibg=#242828
    \|  hi CursorColumn ctermbg=234 guibg=#242828

" Underline spell errors in terminal
autocmd ColorScheme *
    \   hi SpellBad cterm=underline
    \|  hi SpellCap cterm=underline

silent! colorscheme molokai     " Barevné schéma

" Autocommands -------------------------------------------------------------{{{1

" Definovat a resetovat autocmdgroup vimrc
augroup vimrc
    autocmd!

    autocmd BufNewFile * set fileformat=unix
    autocmd Filetype man,help setlocal colorcolumn=0
    autocmd BufNewFile *.sh execute "normal i#!/usr/bin/env basho"

    " Automatické uložení a načtení viewů (foldy, pozice kurzoru, ...)
    autocmd BufLeave,VimLeave *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|    mkview
        \|  endif
    autocmd BufRead *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|    silent! loadview
        \|  endif

    " Vymazání bufferu `q` po spuštění
    autocmd VimEnter * let @q=''
    " Vymazání posledniho hledani po spuštění
    autocmd VimEnter * let @/=''

    " Always start git commit at first line
    autocmd FileType gitcommit exec 'au VimEnter * call setpos(".", [0, 1, 1, 0])'
augroup END

" Mappings -----------------------------------------------------------------{{{1

let mapleader = ","
let g:mapleader = ","

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

" Fold with spacebar
nnoremap <Space> za
vnoremap <Space> zf

" Change default help
nnoremap <F1> :help ide<Cr>

" Faster saving and closing
nnoremap <F2> :w<Cr>
nnoremap <F3> :wq<Cr>
nnoremap <F4> :q<Cr>
nnoremap <S-F2> :wa<Cr>
nnoremap <S-F3> :wqa<Cr>
nnoremap <S-F4> :qa<Cr>

nnoremap <F5> :nohlsearch<Cr>
nnoremap <F6> @q
nnoremap <F7> :TagbarToggle<Cr>
" Custom NERDTree command
nnoremap <F8> :NERDTreeFocusOrClose<Cr>

nnoremap <F9> :make<Cr>

" Quicfix list shortcuts
noremap <C-F5> :clist<Cr>
noremap <C-F6> :cprev<Cr>
noremap <C-F7> :cnext<Cr>
noremap <C-F8> :copen<Cr>

" Word to uppercase
inoremap <C-u> <esc>viwUea

" Typografie
inoremap <Leader><Leader>, „
inoremap <Leader><Leader>' “
inoremap <Leader><Leader>" “
inoremap <Leader><Leader>- –
inoremap <Leader><Leader>. …

" cd to directory of currently edited file
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" Select text that was last edited/pasted.
" `[ `] not working as expected
"nmap gV `[v`]

" Copy/yank X clipboard
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" Yank directory
nnoremap <silent> yd :let @+=expand("%:p:h")<Cr>
" Yank full path
nnoremap <silent> yp :let @+=expand("%:p")<Cr>
" Yank file name
nnoremap <silent> yn :let @+=expand("%:t")<Cr>

" Make file executable
nnoremap <Leader>x :silent !chmod +x %<Cr>

if has('nvim')
    nnoremap <Leader>t :terminal<Cr>
    nnoremap <Leader>T :terminal<Space>
else
    nnoremap <Leader>t :terminal ++close ++curwin<Cr>
    nnoremap <Leader>T :terminal ++curwin<Space>
    vnoremap <Leader>t :terminal<Cr>
    vnoremap <Leader>T :terminal<Space>
endif

" easymotion ---------------------------------------------------------------{{{1

let g:EasyMotion_smartcase = 1

" Character jumps
nmap <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>F <Plug>(easymotion-overwin-f)
nmap <Leader>s <Plug>(easymotion-bd-f2)
nmap <Leader>S <Plug>(easymotion-overwin-f2)

" Faster HJKL motion
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
" Keep cursor column when JK motion
let g:EasyMotion_startofline = 0

" Searching
map  <Leader>/ <Plug>(easymotion-sn)
omap <Leader>/ <Plug>(easymotion-tn)
map  <Leader>n <Plug>(easymotion-next)
map  <Leader>N <Plug>(easymotion-prev)

" airline ------------------------------------------------------------------{{{1

" seznam bufferů
let g:airline#extensions#tabline#enabled = 1

" nezobrazovat splity vpravo nahore
let g:airline#extensions#tabline#show_splits = 0

" indexy tabu
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#tab_nr_type = 1

let g:airline_exclude_preview = 0

let g:airline_powerline_fonts = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Kratsi text modu (insert, replace, ...)
let g:airline_mode_map = {
    \ '__' : '- ',
    \ 'n'  : 'N ',
    \ 'i'  : 'I ',
    \ 'R'  : 'R ',
    \ 'c'  : 'C ',
    \ 'v'  : 'V ',
    \ 'V'  : 'Vl',
    \ '' : 'Vb',
    \ 's'  : 'S ',
    \ 'S'  : 'S ',
    \ '' : 'S ',
    \ }

" přidání ASCII kódu vpravo dole na panel
"let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#:%3v [0x%02B]'
let g:airline_section_z = '%3p%% [0x%02B]'

" Nezobrazovat oddelovace prazdnych sekci (branch apod.)
let g:airline_skip_empty_sections = 1

" Kratsi text v seznamu tabu
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" NERDTree -----------------------------------------------------------------{{{1

let NERDTreeIgnore = ['^__pycache__$[[dir]]', '^tags$[[file]]']

" Nezobrazovat napovedu
let NERDTreeMinimalUI = 1

" Pri mazani souboru automaticky zrusi stary buffer
let NERDTreeAutoDeleteBuffer = 1

function! NERDTreeFocusOrClose()
    if exists('t:NERDTreeBufName') && bufname('%') ==? t:NERDTreeBufName
        execute 'NERDTreeClose'
    else
        execute 'NERDTreeFocus'
    endif
endfun
command! NERDTreeFocusOrClose call NERDTreeFocusOrClose()

" tagbar -------------------------------------------------------------------{{{1

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0

" Grepper ------------------------------------------------------------------{{{1

nnoremap <leader>g :Grepper<cr>
nnoremap <leader>G :Grepper -tool git<cr>
xnoremap <leader>g <plug>(GrepperOperator)

" Initialize g:grepper with default values
runtime plugin/grepper.vim

let g:grepper.tools = ['grep', 'git']
let g:grepper.grep.grepprg .= ' -P -- '
let g:grepper.git.grepprg .= ' -P -- '

let g:grepper.simple_prompt = 1

" Highlight matches
let g:grepper.highlight = 1
" Do not copen/lwindow after grep finished
let g:grepper.open = 0
" Change CWD before grepping
let g:grepper.dir = 'repo,cwd'

let g:grepper.operator.tools = ['grep', 'git']

command! Todo :Grepper -side -query '(TODO|FIXME)'

" CtrlP --------------------------------------------------------------------{{{1

" Maximální počet souborů pro skenování
let g:ctrlp_max_files = 4096
" Maximální zanoření v adresářích
let g:ctrlp_max_depth = 16
" Soubory otevírat v aktuálním okně
let g:ctrlp_open_new_file = 'r'
" Otevírání více souborů: 1 v aktuálním okně a další v nových záložkách
let g:ctrlp_open_multiple_files = 'tjr'
" Prikaz pro vyhledani souboru, g:ctrlp_custom_ignore se pouziva pokud neni
" zadano 'ignore':1
let g:ctrlp_user_command = {
\   'types': {
\       1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
\   },
\   'fallback': 'find %s -type f | grep -vP "(\.git|~$|__pycache__|\.py[co]$|\.o$)"',
\}

" UltiSnips ----------------------------------------------------------------{{{1

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

let g:snips_author = Chomp(system('git config --includes --get user.name 2>/dev/null'))
let g:snips_author_email = Chomp(system('git config --includes --get user.email 2>/dev/null'))

let g:UltiSnipsSnippetDirectories = ["ultisnips"]

" delimitmate --------------------------------------------------------------{{{1

let delimitMate_expand_cr = 1

" Seznam parovych znacek
let delimitMate_matchpairs = "(:),[:],{:}"

au FileType vim,html
    \   let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

au FileType m4,htmlm4
    \   let b:delimitMate_matchpairs = "(:),[:],{:},<:>,`:'"
    \|  let b:delimitMate_quotes = '"'

au FileType python
    \   let b:delimitMate_nesting_quotes = ['"', "'"]

au FileType markdown
    \   let b:delimitMate_nesting_quotes = ['`']

" YouCompleteMe & omnifuncs ------------------------------------------------{{{1

" <Tab> koliduje s UltiSnips
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Zobrazovat i triggery snippetu
let g:ycm_use_ultisnips_completer = 1

" Minimum znaku pro doplnovani
let g:ycm_min_num_of_chars_for_completion = 2

" Python interpreter pro Jedi
"let g:ycm_python_binary_path = '/usr/bin/python3'
" Use python from virtualenv
let g:ycm_python_binary_path = 'python3'

" Zavrit okno s nahledem tagu
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" gutentags ----------------------------------------------------------------{{{1

let g:gutentags_project_root = ['tags']
let g:gutentags_add_default_project_roots = 0

" python-mode --------------------------------------------------------------{{{1

let g:pymode_options = 1
let g:pymode_options_colorcolumn = 1
let g:pymode_options_max_line_length = 79
let g:pymode_folding = 0

let g:pymode_python = 'python3'
let g:pymode_syntax_print_as_function = 1

let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 0

let g:pymode_rope = 0

" go -----------------------------------------------------------------------{{{1

let g:go_template_autocreate = 0

" indent-guides ------------------------------------------------------------{{{1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

let g:indent_guides_auto_colors = 0
autocmd VimEnter,ColorScheme *
    \   hi IndentGuidesOdd ctermbg=235 guibg=#262626
    \|  hi IndentGuidesEven ctermbg=235 guibg=#262626

" trailing-whitespace ------------------------------------------------------{{{1

let g:extra_whitespace_ignored_filetypes = ['mail']

" vimtex -------------------------------------------------------------------{{{1

let g:vimtex_quickfix_mode = 0

