" Esc2回でハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>
nmap <C-j><C-j> :nohlsearch<CR><Esc>

" Hで行頭へ移動する
map H ^
" Lで行末へ移動する
map L $
" Ctrl+jでEsc
noremap <C-j> <Esc>
noremap! <C-j> <Esc>

if has('win32') || has('win64')
  " WSL clipboardへコピー
  nnoremap <silent> <Space>y :.w !win32yank.exe -i<CR><CR>
  vnoremap <silent> <Space>y :w !win32yank.exe -i<CR><CR>
  nnoremap <silent> <Space>p :r !win32yank.exe -o<CR>
  vnoremap <silent> <Space>p :r !win32yank.exe -o<CR>
endif

map <leader>j :call JsBeautify()<cr>
