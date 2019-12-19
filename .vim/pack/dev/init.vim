" Pack dev/youcompleteme ---------------------------------------------------{{{1

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

" Pack dev/editorconfig ----------------------------------------------------{{{1

" Don't change formations (adds 't' when max_line_length is set).
let g:EditorConfig_preserve_formatoptions = 1

" Set only 'textwidth', don't change colorcolumn.
let g:EditorConfig_max_line_indicator = 'none'

" Pack dev/gitgutter -------------------------------------------------------{{{1

let g:gitgutter_map_keys = 0

nmap <leader>dp <Plug>GitGutterPreviewHunk
nmap <leader>ds <Plug>GitGutterStageHunk
nmap <leader>du <Plug>GitGutterUndoHunk

nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

" Pack dev/python-mode -----------------------------------------------------{{{1

let g:pymode_options = 0

let g:pymode_preview_height = 12
let g:pymode_preview_position = 'below'

let g:pymode_folding = 0
let g:pymode_indent = 1

let g:pymode_python = 'python3'
let g:pymode_syntax_print_as_function = 1

let g:pymode_run_bind = '<F10>'
let g:pymode_rope_completion_bind = '<C-Space>'

let g:pymode_lint = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 0

" Warn only if line length exceeds max line length by more than 10%.
" flake8 --max-line-length=80 --select=C,E,F,W,B,B950 --ignore=E501
let g:pymode_lint_select = ['C', 'E', 'F', 'W', 'B', 'B950']
let g:pymode_lint_ignore = ['E501']

let g:pymode_lint_options_pep8 = {'max_line_length': &textwidth}
let g:pymode_lint_options_pylint = {'errors-only': 1}

let g:pymode_rope = 1

if !(isdirectory('.git') || isdirectory('.ropeproject'))
    " Create .ropeproject in /tmp not in PWD
    let g:pymode_rope_project_root = tempname()
endif

let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 0

let g:pymode_rope_show_doc_bind = 'K'
let g:pymode_rope_goto_definition_bind = 'gd'

let g:pymode_rope_rename_bind = '<Leader>rr'
let g:pymode_rope_rename_module_bind = '<Leader>r1r'
let g:pymode_rope_organize_imports_bind = '<Leader>ro'
let g:pymode_rope_module_to_package_bind = '<Leader>r1p'
let g:pymode_rope_extract_method_bind = '<Leader>rm'
let g:pymode_rope_extract_variable_bind = '<Leader>rl'
let g:pymode_rope_use_function_bind = '<Leader>ru'
let g:pymode_rope_use_function_bind = '<Leader>ru'
let g:pymode_rope_change_signature_bind = '<Leader>rs'

" Pack dev/go --------------------------------------------------------------{{{1

let g:go_template_autocreate = 0

" Using YCM instead
let g:go_code_completion_enabled = 0

" Pack dev/vimtex ----------------------------------------------------------{{{1

let g:vimtex_quickfix_mode = 0

