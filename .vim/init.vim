" Settings -----------------------------------------------------------------{{{1

set nocompatible

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
let g:user_name = Chomp(system('git config --includes --get user.name 2>/dev/null'))
let g:user_email = Chomp(system('git config --includes --get user.email 2>/dev/null'))

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

    " Always start git commit at first line and change foldmethod
    autocmd FileType gitcommit
        \   exec 'au VimEnter * call setpos(".", [0, 1, 1, 0])'
        \|  setlocal foldmethod=syntax
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
" <F7>, <F8> mapped by plugins
nnoremap <F9> :make<Cr>

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

" Yank directory
nnoremap <silent> yd :let @+=expand("%:p:h")<Cr>
" Yank full path
nnoremap <silent> yp :let @+=expand("%:p")<Cr>
" Yank file name
nnoremap <silent> yn :let @+=expand("%:t")<Cr>

" Make file executable
nnoremap <Leader>x :silent !chmod +x %<Cr>

" Close preview window
nnoremap <Leader>z <C-W>z

if has('nvim')
    nnoremap <Leader>t :terminal<Cr>
    nnoremap <Leader>T :terminal<Space>
else
    nnoremap <Leader>t :terminal ++close ++curwin<Cr>
    nnoremap <Leader>T :terminal ++curwin<Space>
    vnoremap <Leader>t :terminal<Cr>
    vnoremap <Leader>T :terminal<Space>
endif

" Pack base/airline --------------------------------------------------------{{{1

let g:airline_powerline_fonts = 1
" Nezobrazovat oddelovace prazdnych sekci (branch apod.)
let g:airline_skip_empty_sections = 1

" Kratsi text modu (insert, replace, ...)
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'c'  : 'C',
    \ 'i'  : 'I',
    \ 'ic' : 'I',
    \ 'ix' : 'I',
    \ 'n'  : 'N',
    \ 'ni' : 'N',
    \ 'no' : 'N',
    \ 'R'  : 'R',
    \ 'Rv' : 'R',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ 't'  : 'T',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ }

" přidání ASCII kódu vpravo dole na panel
"let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#:%3v [0x%02B]'
let g:airline_section_z = '%3p%% [0x%02B]'

" Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0

" Tab indexes
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#tab_nr_type = 1

" Shorter text in tabs
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_close_button = 0

" Filename formatting in tabs
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" Tab switching
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" Other airline plugins
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

" Pack base/ctrlp ----------------------------------------------------------{{{1

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

" Pack base/easymotion -----------------------------------------------------{{{1

let g:EasyMotion_smartcase = 1

" Character jumps
nmap <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>F <Plug>(easymotion-overwin-f)

" Faster HJKL motion
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
" Keep cursor column when JK motion
let g:EasyMotion_startofline = 0

" Searching
map  <Leader>/ <Plug>(easymotion-sn)
map  <Leader>n <Plug>(easymotion-next)
map  <Leader>N <Plug>(easymotion-prev)
let g:EasyMotion_add_search_history = 0

" Pack base/grepper --------------------------------------------------------{{{1

nnoremap <leader>g :Grepper<cr>
nmap gs <plug>(GrepperOperator)
vmap gs <plug>(GrepperOperator)

" Initialize g:grepper with default values.
runtime PACK plugin/grepper.vim

let g:grepper.tools = ['grep', 'git']
let g:grepper.grep.grepprg .= ' -P -- '
let g:grepper.git.grepprg .= ' -P -- '

let g:grepper.simple_prompt = 1

" Highlight matches
let g:grepper.highlight = 1
" Use location list, not quickfix
let g:grepper.quickfix = 0
" Do not copen/lwindow after grep finished
let g:grepper.open = 0
" Change CWD before grepping
let g:grepper.dir = 'repo,cwd'

let g:grepper.operator.tools = ['grep', 'git']

command! Todo :Grepper -noprompt -side -query '(TODO|FIXME)'

" Pack base/indent-guides --------------------------------------------------{{{1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'org']

let g:indent_guides_auto_colors = 0
autocmd VimEnter,ColorScheme *
    \   hi IndentGuidesOdd ctermbg=235 guibg=#262626
    \|  hi IndentGuidesEven ctermbg=235 guibg=#262626

" Pack base/nerdtree -------------------------------------------------------{{{1

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

nnoremap <F8> :NERDTreeFocusOrClose<Cr>

" Pack base/template -------------------------------------------------------{{{1

let g:templates_no_builtin_templates = 1

" Global templates config
let g:templates_directory = ['~/.vim/templates']
let g:templates_global_name_prefix = 'template:'

" Change %USER% and %MAIL% value
let g:username = g:user_name
let g:email = g:user_email

let g:templates_user_variables = [
    \   ['PARENT', 'TV_Parent']
    \ ]

function! TV_Parent()
    return expand('%:p:h:t')
endfunction

" Pack dev/youcompleteme ---------------------------------------------------{{{1

" <Tab> koliduje s UltiSnips
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Zobrazovat i triggery snippetu
let g:ycm_use_ultisnips_completer = 1

" Minimum znaku pro doplnovani
let g:ycm_min_num_of_chars_for_completion = 2

" Zavrit okno s nahledem tagu
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_collect_identifiers_from_tags_files = 0

nmap <Leader>K :YcmCompleter GetDoc<Cr>
nmap <Leader>G :YcmCompleter GoTo<Cr>

" Pack dev/ultisnips -------------------------------------------------------{{{1

let g:snips_author = g:user_name
let g:snips_author_email = g:user_email

let g:UltiSnipsSnippetDirectories = ["ultisnips"]

" Pack dev/tagbar ----------------------------------------------------------{{{1

nnoremap <F7> :TagbarToggle<Cr>

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1

" Pack dev/gutentags -------------------------------------------------------{{{1

let g:gutentags_project_root = ['tags']
let g:gutentags_add_default_project_roots = 0

" Pack dev/delimitmate -----------------------------------------------------{{{1

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

" Pack dev/better-whitespace -----------------------------------------------{{{1

let g:better_whitespace_filetypes_blacklist = ['mail', 'diff', 'gitcommit', 'help']
let g:show_spaces_that_precede_tabs = 1

" Pack dev/gitgutter -------------------------------------------------------{{{1

let g:gitgutter_map_keys = 0

nmap <leader>dp <Plug>GitGutterPreviewHunk
nmap <leader>ds <Plug>GitGutterStageHunk
nmap <leader>du <Plug>GitGutterUndoHunk

nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

" Pack dev/python-mode -----------------------------------------------------{{{1

let g:pymode_options = 1
let g:pymode_options_colorcolumn = 1
let g:pymode_options_max_line_length = 79

let g:pymode_folding = 0
let g:pymode_indent = 1

let g:pymode_python = 'python3'
let g:pymode_syntax_print_as_function = 1

let g:pymode_lint = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 0

let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint = {'errors-only': 1}

let g:pymode_rope = 1
" Create .ropeproject in /tmp not in PWD
let g:pymode_rope_project_root = tempname()

let g:pymode_rope_completion = 0

let g:pymode_rope_show_doc_bind = 'K'
let g:pymode_rope_goto_definition_bind = 'gd'
let g:pymode_rope_rename_bind = '<Leader>R'
let g:pymode_rope_organize_imports_bind = '<Leader>I'

" Pack dev/go --------------------------------------------------------------{{{1

let g:go_template_autocreate = 0

" Pack dev/vimtex ----------------------------------------------------------{{{1

let g:vimtex_quickfix_mode = 0

" Pack org/* ---------------------------------------------------------------{{{1

let g:org_indent = 1
let g:org_aggressive_conceal = 1

let g:org_todo_keywords=['TODO', 'WIP', '|', 'DONE']

" Open link in firefox
let g:utl_cfg_hdl_scm_http_system = "silent !firefox '%u' &"

