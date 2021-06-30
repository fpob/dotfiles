" airline ------------------------------------------------------------------{{{1

let g:airline_powerline_fonts = 1
" Do not draw separators for empty sections.
let g:airline_skip_empty_sections = 1

" Shorter mode text.
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

" Don't show 'utf-8[unix]', it is expected, show encoding/format only when it is
" something else.
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

" Percentage and ASCII code of character under cursor.
let g:airline_section_z = '%3p%% [0x%02B]'

" Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0

" Tab indexes
let g:airline#extensions#tabline#tab_nr_type = 1

" Shorter text in tabs
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#show_close_button = 0

" Hide 'tab number/count' in the right side
let g:airline#extensions#tabline#show_tab_count = 0

" Filename formatting in tabs
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" Tab switching
let g:airline#extensions#tabline#buffer_idx_mode = 1
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

" ctrlp --------------------------------------------------------------------{{{1

" The maximum number of files to scan
let g:ctrlp_max_files = 4096
" The maximum depth of a directory tree to recurse into
let g:ctrlp_max_depth = 16
" Open file in the current window
let g:ctrlp_open_new_file = 'r'
" Open multiple files in tabs, first file the current window
let g:ctrlp_open_multiple_files = 'tr'
" External tool to use for listing files
let g:ctrlp_user_command = {
\   'types': {
\       1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
\   },
\   'fallback': join([
\       "find %s -type f",
\       "-not -name '*~'",
\       "-not -name '*.o'",
\       "-not -name '*.pyc'",
\       "-not -path '*/__pycache__/*'",
\       "-not -path '*/.git/*'",
\       "-not -path '*/.venv/*'",
\       "-not -path '*/.tox/*'",
\   ], " ")
\}

" easymotion ---------------------------------------------------------------{{{1

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
map <Leader>/ <Plug>(easymotion-sn)
map <Leader>n <Plug>(easymotion-next)
map <Leader>N <Plug>(easymotion-prev)
" Don't add search pattern to @/.
let g:EasyMotion_add_search_history = 0

" grepper ------------------------------------------------------------------{{{1

nnoremap <leader>g :Grepper<cr>
nmap gs <plug>(GrepperOperator)
vmap gs <plug>(GrepperOperator)

" Initialize g:grepper with default values.
runtime PACK plugin/grepper.vim

let g:grepper.tools = ['git', 'grep']
let g:grepper.grep.grepprg = 'grep -RIn --exclude-dir={.bzr,CVS,.git,.hg,.svn,.tox,.venv}'
let g:grepper.git.grepprg = 'git grep -nGI'

let g:grepper.simple_prompt = 1

" Highlight matches
let g:grepper.highlight = 1
" Use location list, not quickfix
let g:grepper.quickfix = 0
" Do not copen/lwindow after grep finished
let g:grepper.open = 1
" Change CWD before grepping
let g:grepper.dir = 'repo,cwd'

command! Todo :Grepper -noprompt -query '(TODO|FIXME)'

" indent-guides ------------------------------------------------------------{{{1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Disable on TABs
let g:indent_guides_tab_guides = 0

" Disable default mapping <Leader>ig
let g:indent_guides_default_mapping = 0

let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" Use custom colors
let g:indent_guides_auto_colors = 0

augroup vimrc_indent_guides
    autocmd!
    autocmd VimEnter,ColorScheme *
        \   hi IndentGuidesOdd ctermbg=235 guibg=#262626
        \|  hi IndentGuidesEven ctermbg=234 guibg=#212121
augroup END

" nerdtree -----------------------------------------------------------------{{{1

let NERDTreeIgnore = [
    \   '^__pycache__$[[dir]]',
    \   '^\.git$',
    \   '^\.\(ropeproject\|tox\|pytest_cache\|cache\|venv\|direnv\)$[[dir]]',
    \   '^\.\(coverage\(\..*\)\?\)$[[file]]',
    \   '^tags\(\.temp\|\.lock\)\?$[[file]]'
    \]

" Dont show help
let NERDTreeMinimalUI = 1
" Show hidden files by default
let NERDTreeShowHidden = 1
" When deleting file delete also buffer
let NERDTreeAutoDeleteBuffer = 1

" Custom function+command to focus NERDTree if it is not currently window and if
" is active then close it.
function! NERDTreeFocusOrClose()
    if exists('t:NERDTreeBufName') && bufname('%') ==? t:NERDTreeBufName
        execute 'NERDTreeClose'
    else
        execute 'NERDTreeFocus'
    endif
endfun
command! NERDTreeFocusOrClose call NERDTreeFocusOrClose()

nnoremap <F8> :NERDTreeFocusOrClose<Cr>

" template -----------------------------------------------------------------{{{1

let g:templates_no_builtin_templates = 1

" Global templates config
let g:templates_directory = ['~/.vim/templates']
let g:templates_global_name_prefix = 'template:'

" Change %USER% and %MAIL% value
let g:username = g:user_name
let g:email = g:user_email

" Custom variables, mapping variable-name -> value generator (function name)
let g:templates_user_variables = [
    \   ['PARENT', 'GetParentDirName']
    \ ]

function! GetParentDirName()
    return expand('%:p:h:t')
endfunction
