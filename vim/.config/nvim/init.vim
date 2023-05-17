call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Statusline
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Vinegar ('-' to browse files etc.)
Plug 'tpope/vim-vinegar'

" Color schemes
Plug 'flazz/vim-colorschemes'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'

" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Formatting
Plug 'sbdchd/neoformat'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""
" Syntax and Completion
"""""""""""""""""""""""""""""""""""""""""""""""

syntax on
filetype indent plugin on

let g:tex_flavor = "latex"

"""""""""""""""""""""""""""""""""""""""""""""""
" Start Lualine
"""""""""""""""""""""""""""""""""""""""""""""""

lua require('lualine').setup()

"""""""""""""""""""""""""""""""""""""""""""""""
" Look
"""""""""""""""""""""""""""""""""""""""""""""""

" keep curser in the middle of the screen if possible
set scrolloff=999

" Color scheme
color 256-jungle

" set relativenumber function mapped on ctrl-n (see section Key mappings)
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

set number
set textwidth=80
set colorcolumn=80
set splitright
set splitbelow
set ignorecase
set smartcase
set hidden
set nobackup
set cursorline

set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300

"""""""""""""""""""""""""""""""""""""""""""""""
" Import lua configs
"""""""""""""""""""""""""""""""""""""""""""""""

lua require("rust")
lua require("go")
lua require("treesitter")
lua require("clangd")
lua require("python")

"""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""

" leader key
let mapleader=','

" Tab navigation
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Insert date
nmap <F5> a<C-R>=strftime("%a %d %b %Y")<CR><Esc>
imap <F5> <C-R>=strftime("%a %d %b %Y")<CR>

" Insert Date in ID format
nmap <F6> a<C-R>=strftime("%Y%m%d%H%M")<CR><Esc>
imap <F6> <C-R>=strftime("%Y%m%d%H%M")<CR>

" move lines
map <up> ddkP
map <down> ddjP

" Navigate quickfix list
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" toggle between relative and absolute line numbers
nnoremap <C-l> :call NumberToggle()<cr>

" clear search highlighting
nnoremap <leader>c :nohl<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>

" Quick-fix
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Show diagnostic popup on cursor hover
"autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" Snippet Key Mappings
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


""""""""""""""""""""""""""""""""""""""""""""""""
" Golang Config
"""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufWritePre *.go lua vim.lsp.buf.format()
autocmd BufWritePre *.cpp lua vim.lsp.buf.format()
autocmd BufWritePre *.h lua vim.lsp.buf.format()
autocmd BufWritePre *.rs lua vim.lsp.buf.format()
autocmd BufWritePre *.go lua go_org_imports(1000)
