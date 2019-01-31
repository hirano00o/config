set term=screen-256color 
set fenc=utf-8
set ambiwidth=double
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set cursorline
set cursorcolumn
set smartindent
set showmatch
set laststatus=2
set cmdheight=2
if !has('gui_running')
  set mouse=
  set ttimeoutlen=0
  if $COLORTERM == "truecolor"
    set termguicolors
  endif
endif
set nofixendofline
set formatoptions+=mM
set tabstop=2
set shiftwidth=2
set expandtab

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set ruler
let &colorcolumn=join(range(121,999),",")
hi ColorColumn ctermbg=235 guibg=#2c2d27 
nmap <Esc><Esc> :nohlsearch<CR><Esc>
noremap!  



call plug#begin('~/.vim/plugged')
  Plug 'junegunn/vim-plug',
       \ {'dir': '~/.vim/plugged/vim-plug/autoload'}
  Plug 'fatih/vim-go'
  Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
  call plug#end()
:

" vim-go設定
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>i <Plug>(go-info)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

au FileType go :highlight goErr cterm=bold ctermfg=214
au FileType go :match goErr /\<err\>/

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
