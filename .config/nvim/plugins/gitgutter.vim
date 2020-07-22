set updatetime=1000
let g:gitgutter_sign_added = 'xx'
let g:gitgutter_sign_modified = 'yy'
let g:gitgutter_sign_removed = 'zz'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_modified_removed = 'ww'
highlight GitGutterAdd ctermfg=green ctermbg=brown
highlight GitGutterChange ctermfg=blue ctermbg=brown
highlight GitGutterDelete ctermfg=red ctermbg=brown
highlight GitGutterChangeDelete ctermfg=yellow ctermbg=brown
nmap <Leader>hp <Plug>GitGutterPreviewHunk

