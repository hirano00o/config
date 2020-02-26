let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'  ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'  ] ]
      \ },
      \ 'component_function': {
      \   'linetotal': 'LightLineTotal',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
let g:lightline.component = {
    \ 'lineinfo': '[%3l/%3L]:%-2v'
    \ }

