augroup EnableJS
    autocmd!
augroup END

function! EnableJavascript()
    let g:used_javascript_libs = 'jquery,underscore,react,vue,jasmine,chai,d3'
    let b:javascript_lib_use_jquery = 1
    let b:javascript_lib_use_underscore = 1
    let b:javascript_lib_use_react = 1
    let b:javascript_lib_use_vue = 1
    let b:javascript_lib_use_jasmine = 1
    let b:javascript_lib_use_chai = 1
    let b:javascript_lib_use_d3 = 1
endfunction
autocmd EnableJS FileType javascript,javascript.jsx call EnableJavascript()

