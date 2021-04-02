" Esc2回でハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>
nmap <C-j><C-j> :nohlsearch<CR><Esc>

" Hで行頭へ移動する
map H ^
" Lで行末へ移動する
map L $
" jjでEsc
inoremap <silent>jj <Esc>

if has('win32') || has('win64')
  " WSL clipboardへコピー
  nnoremap <silent> <Space>y :.w !win32yank.exe -i<CR><CR>
  vnoremap <silent> <Space>y :w !win32yank.exe -i<CR><CR>
  nnoremap <silent> <Space>p :r !win32yank.exe -o<CR>
  vnoremap <silent> <Space>p :r !win32yank.exe -o<CR>
endif

map <leader>j :call JsBeautify()<cr>

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
" Tab jump
nmap    t [Tag]
" tN で1番左から N 番目のタブへ移動
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" tc で新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" td でタブを閉じる
map <silent> [Tag]d :tabclose<CR>
" Ctrl-l で右のタブ
map <silent> <C-l> :tabnext<CR>
" Ctrl-h で左のタブ
map <silent> <C-h> :tabprevious<CR>

if executable('jq')
  function! s:jq(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!jq' string(a:0 == 0 ? '.' : a:1)
    if !v:shell_error || a:has_bang
      return
    endif
    let error_lines = filter(getline('1', '$'), 'v:val =~# "^parse error: "')
    " 範囲指定している場合のために，行番号を置き換える
    let error_lines = map(error_lines, 'substitute(v:val, "line \\zs\\(\\d\\+\\)\\ze,", "\\=(submatch(1) + a:firstline - 1)", "")')
    let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
    " カレントバッファがエラーメッセージになっているので，元に戻す
    undo
    " カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
    execute 'botright' winheight 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    call setline(1, error_lines)
    " エラーメッセージ用バッファのundo履歴を削除(エラーã¡ッセージをundoで消去しないため)
    let save_undolevels = &l:undolevels
    setlocal undolevels=-1
    execute "normal! a \<BS>\<Esc>"
    setlocal nomodified
    let &l:undolevels = save_undolevels
    " エラーメッセージ用バッファは読み取り専用にしておく
    setlocal readonly
  endfunction
  command! -bar -bang -range=% -nargs=? Jq  <line1>,<line2>call s:jq(<bang>0, <f-args>)
endif
