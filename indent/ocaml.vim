if exists("ocaml_use_ocp_indent")
    let path = expand('<sfile>:p:h')
    exec 'source ' path . '/ocp-indent.vim'
else
    let path = expand('<sfile>:p:h')
    exec 'source ' path . '/default-indent.vim'
endif
