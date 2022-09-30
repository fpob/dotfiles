-- Settings ----------------------------------------------------------------{{{1

local HOME = vim.env.HOME

vim.o.backupdir = HOME .. "/.local/share/nvim/backup//"
vim.o.directory = HOME .. "/.local/share/nvim/swap//"
vim.o.undodir = HOME .. "/.local/share/nvim/undo//"
vim.o.viewdir = HOME .. "/.local/share/nvim/view//"

vim.o.backup = true  -- make backup before overwriting a file
vim.o.undofile = true  -- persistent undo
vim.o.number = true
vim.o.expandtab = true  -- expand tab to spaces
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.foldmethod = "marker"
vim.o.title = true  -- set terminal title
vim.o.titlestring = "nvim: %t %r%m"
vim.o.cursorline = true  -- higlight cursor line
vim.o.confirm = true  -- don't fail, instead show a dialog
vim.o.list = true  -- display some whitespace chars, see 'listchars'
vim.o.listchars = "tab:› ,nbsp:~"
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
vim.o.virtualedit = "block" -- cursor can be positioned where there is no char
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.textwidth = 80
vim.o.mouse = "a"  -- enable mouse
vim.o.wrap = true
vim.o.linebreak = true  -- don't wrap words in the middle, see 'breakat'
vim.o.breakindent = true
vim.o.showbreak = "↳"
vim.o.showmode = false  -- handled by plugin 'mini.statusline'
vim.o.lazyredraw = true
vim.o.clipboard = "unnamedplus"  -- use '+' register for all y/d/c operations
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.completeopt = "menu,noselect,noinsert"
vim.o.formatoptions = "cqj"
vim.o.signcolumn = "number"
vim.o.spelllang = "en,cs"

vim.diagnostic.config {
  signs = false,
}

-- Utils -------------------------------------------------------------------{{{1

-- Execute command and return the output.
function sh(cmd)
  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()
  return string.gsub(output, "\n$", "")
end

-- Shortcut to create a mapping.
function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or { noremap = true, silent = true })
end

-- Mappings ----------------------------------------------------------------{{{1

vim.g.mapleader = ","

-- Keep selection when indenting/outdenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Tab switching
map("n", "<C-h>", "gT")
map("n", "<C-l>", "gt")

-- Window switching (alt)
map("n", "<M-h>", "<C-w>h")
map("n", "<M-l>", "<C-w>l")
map("n", "<M-k>", "<C-w>k")
map("n", "<M-j>", "<C-w>j")
-- ... in terminal
map("t", "<M-h>", "<C-\\><C-n><C-w>h")
map("t", "<M-l>", "<C-\\><C-n><C-w>l")
map("t", "<M-k>", "<C-\\><C-n><C-w>k")
map("t", "<M-j>", "<C-\\><C-n><C-w>j")

-- Word to uppercase
map("i", "<C-u>", "<Esc>viwUea")

-- Faster saving and closing
map("n", "<F2>", "<Cmd>w<CR>")
map("n", "<F3>", "<Cmd>x<CR>")
map("n", "<F4>", "<Cmd>q<CR>")

-- Terminal in split
map("n", "<Leader>tj", "<Cmd>new +terminal<CR>")
map("n", "<Leader>tl", "<Cmd>vnew +terminal<CR>")

-- Un-highlight search, update diff and refresh screen
map("n", "<F5>", "<Cmd>nohlsearch<Bar>diffupdate<CR>")

-- Autocommands ------------------------------------------------------------{{{1

vim.cmd [[
 augroup terminal
   autocmd!
   " Enter insert mode automatically
   autocmd TermOpen * startinsert
   " Enter insert mode when entering terminal
   autocmd BufEnter term://* startinsert
   " Disable number lines and fold column in terminal window
   autocmd TermOpen * setlocal nonumber norelativenumber
   " Refresh virt-column
   autocmd TermOpen * silent! VirtColumnRefresh
 augroup END
]]

-- LSP ---------------------------------------------------------------------{{{1

-- Use an on_attach function to only map the following keys after the language
-- server attaches to the current buffer.
local function lsp_on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings. See `:help vim.lsp.*` for documentation on any of the below functions
  local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K', vim.lsp.buf.hover)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('n', '<C-k>', vim.lsp.buf.signature_help)
  map('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder)
  map('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder)
  map('n', '<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  map('n', '<Leader>D', vim.lsp.buf.type_definition)
  map('n', '<Leader>r', vim.lsp.buf.rename)
  map('n', '<Leader>a', vim.lsp.buf.code_action)
  map('n', 'gr', vim.lsp.buf.references)
  map('n', '<Leader>F', vim.lsp.buf.formatting)
end

local lspconfig = require("lspconfig")
lspconfig.jedi_language_server.setup { on_attach = lsp_on_attach }
lspconfig.gopls.setup { on_attach = lsp_on_attach }

-- Plugins -----------------------------------------------------------------{{{1

-- onedark --

local onedark = require("onedark")
onedark.setup {
  style = "warmer",
  toggle_style_key = "<nop>",  -- disable
  term_colors = false,
  code_style = {
    comments = 'none',  -- disable italic for comments
  },
}
onedark.load()

-- nvim-treesitter --

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua", "python", "go", "bash", "json", "yaml", "toml", "rst", "make",
  },
  highlight = { enable = true },
  yati = { enable = true }
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
}

parser_config.nix = {
  install_info = {
    url = "https://github.com/cstrahan/tree-sitter-nix",
    branch = "main",
    files = { "src/parser.c", "src/scanner.c" },
  },
}

-- nvim-tree ---

require("nvim-tree").setup {
  view = {
    signcolumn = "no",
  },
  renderer = {
    special_files = {},
  },
  filters = {
    custom = {
      "^\\.git$",
    },
  },
}

map("n", "<F8>", "<Cmd>NvimTreeToggle<CR>")

-- mini --

require("mini.comment").setup {}

require("mini.completion").setup {}

require("mini.statusline").setup {}

require("mini.surround").setup {
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",
  }
}

vim.keymap.del("x", "ys")
map("x", "S", ":<C-u>lua MiniSurround.add('visual')<CR>")

-- tidy --

require("tidy").setup {
  filetype_exclude = { "mail", "diff", "help" },
}

-- virt-column --

require("virt-column").setup {
  char = "▏",
  virtcolumn = "+1,+9",
}

-- telescope --

require("telescope").setup {}

map("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>g", "<Cmd>Telescope live_grep<CR>")
map("n", "<Leader>b", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>h", "<Cmd>Telescope help_tags<CR>")
map("n", "<Leader>s", "<Cmd>Telescope treesitter<CR>")

-- luatab --

require("luatab").setup {
  devicon = function(bufnr)
    local buftype = vim.fn.getbufvar(bufnr, "&buftype")
    if buftype == "help" then
      return "  "
    elseif buftype == "terminal" then
      return "  "
    end
    return ""
  end,
  separator = function(index)
    if index < vim.fn.tabpagenr("$") then
      return "%#TabLine#│"
    end
    return ""
  end,
  windowCount = function() return "" end
}

-- pounce --

require("pounce").setup {
  multi_window = false,
}

vim.cmd [[
  hi PounceMatch gui=NONE guifg=#5a5b5e guibg=#8fb573
  hi PounceGap gui=NONE guifg=#5a5b5e guibg=#8fb573
  hi PounceAccept gui=bold guifg=#5a5b5e guibg=#57a5e5
  hi PounceAcceptBest gui=bold guifg=#5a5b5e guibg=#de5d68
]]

map("n", "-", "<Cmd>Pounce<CR>")
map("n", "_", "<Cmd>PounceRepeat<CR>")

-- snippy --

require("snippy").setup {
  mappings = {
    is = {
      ['<Tab>'] = 'expand_or_advance',
      ['<S-Tab>'] = 'previous',
    },
    nx = {
      ['<Tab>'] = 'cut_text',
    },
  },
}

-- autopairs --

local autopairs = require('nvim-autopairs')
autopairs.setup {
  map_cr = false,
}

local function cr()
  if vim.fn.pumvisible() ~= 0 then
    return autopairs.esc('<C-y>') .. autopairs.autopairs_cr()
  end
  return autopairs.autopairs_cr()
end

map('i', '<Enter>', cr, { expr = true, noremap = true })
