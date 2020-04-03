if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  nmap <silent> K :LspHover<CR>
  nmap <silent> td :LspTypeDefinition<CR>
  nmap <silent> <Leader>r :LspReferences<CR>
  nmap <silent> <Leader>i :LspImplementation<CR>
  nmap <silent> <Leader>d :LspDocumentDiagnostics<CR>
  nmap <silent> <Leader>n :LspNextDiagnostic<CR>
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
  au BufWritePre *.go LspDocumentFormatSync
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 300
let g:lsp_text_edit_enabled = 1

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

