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
let g:airline#extensions#whitespace#enabled = 0

" better-whitespace --------------------------------------------------------{{{1

let g:better_whitespace_filetypes_blacklist = ['mail', 'diff', 'gitcommit', 'help']
let g:show_spaces_that_precede_tabs = 1

let g:better_whitespace_operator='<Leader>t'

" Don't strip whitespaces on save
let g:strip_whitespace_on_save = 0
" Don't ask for confirmation
let g:strip_whitespace_confirm = 0
" Strip empty lines at the end of file
let g:strip_whitelines_at_eof = 1

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
\       "-not -path '*/.tox/*'",
\       "-not -path '*/.direnv/*'",
\   ], " ")
\}

" Close NERDTree window
let g:ctrlp_dont_split = 'NERD'

" delimitmate --------------------------------------------------------------{{{1

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

let g:delimitMate_matchpairs = "(:),[:],{:}"

" direnv -------------------------------------------------------------------{{{1

let g:direnv_auto = 0

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

" gitgutter ----------------------------------------------------------------{{{1

" Disable default mappings
let g:gitgutter_map_keys = 0

nmap <leader>dp <Plug>(GitGutterPreviewHunk)
nmap <leader>ds <Plug>(GitGutterStageHunk)
nmap <leader>du <Plug>(GitGutterUndoHunk)

nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)

" go -----------------------------------------------------------------------{{{1

let g:go_template_autocreate = 0

" Using YCM instead
let g:go_code_completion_enabled = 0

" Disable errors and warnings highlighting
let g:go_highlight_diagnostic_errors = 0
let g:go_highlight_diagnostic_warnings = 0

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

" python-mode --------------------------------------------------------------{{{1

" Disable changing some options, see docs
let g:pymode_options = 0

" Change preview appearance (documentation and run output)
let g:pymode_preview_height = 12
let g:pymode_preview_position = 'below'

let g:pymode_folding = 0
let g:pymode_indent = 1

let g:pymode_python = 'python3'
let g:pymode_syntax_print_as_function = 1

let g:pymode_run_bind = '<F10>'

" Disable lint checks, flake8 is not supported
let g:pymode_lint = 0

" Enable rope. Required to make gd, K, etc. work.
let g:pymode_rope = 1

" Disable project regen on every save. Auroregex is slowing down vim a lot.
let g:pymode_rope_regenerate_on_write = 0

augroup vimrc_pymode
    autocmd!
    " Regenerate command is available only in python files.
    autocmd FileType python nmap <C-c>R :PymodeRopeRegenerate<Cr>
augroup END

" Seems completion is not needed, YCM is enough
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

let g:pymode_rope_show_doc_bind = 'K'

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

" ultisnips ----------------------------------------------------------------{{{1

let g:snips_author = g:user_name
let g:snips_author_email = g:user_email

let g:UltiSnipsSnippetDirectories = ["ultisnips"]

" vimtex -------------------------------------------------------------------{{{1

let g:vimtex_quickfix_mode = 0

let g:tex_flavor = 'latex'

" youcompleteme ------------------------------------------------------------{{{1

" <Tab> is used by UltiStip
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Show ultisnip IDs
let g:ycm_use_ultisnips_completer = 1

" Disable completion auto-triggering
let g:ycm_min_num_of_chars_for_completion = 256

" Automatically close preview window
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_collect_identifiers_from_tags_files = 1

" Disable syntax errors signs
let g:ycm_enable_diagnostic_signs = 0

" Disable documentation pop-up
let g:ycm_auto_hover = ''

nmap K :YcmCompleter GetDoc<Cr>
nmap gd :YcmCompleter GoTo<Cr>
