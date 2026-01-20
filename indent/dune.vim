" Vim indent file
" Language: dune
" Maintainers:  Markus Mottl         <markus.mottl@gmail.com>
" URL:          https://github.com/ocaml/vim-ocaml
" Last Change:  2024 Nov 8 -  Make vim respect the tab width settings (Stephen Sherratt)
"               2020 Dec 31

if exists("b:did_indent")
 finish
endif
let b:did_indent = 1

" A rough approximation of the indentation behaviour implemented by
" `dune format-dune-file`.
function! DuneIndent()
    let prev_line = getline(v:lnum - 1)
    let prev_indent = indent(v:lnum - 1)
    let current_indent = prev_indent
    for i in range(len(prev_line))
        if prev_line[i] == '('
            let current_indent += &shiftwidth
        endif
        if prev_line[i] == ')'
            let current_indent -= &shiftwidth
        endif
    endfor
    return current_indent
endfunction

" dune format-dune-file uses 1 space to indent
" Explicitly set "lisp" since without this setting vim will not auto indent
" sexp files like dune files at all. When "lisp" is enabled, vim doesn't
" respect softtabstop or shiftwidth by default, so a custom indentexpr is
" needed.
setlocal softtabstop=1 shiftwidth=1 expandtab lisp indentexpr=DuneIndent() lispoptions=expr:1

let b:undo_indent = "setl et< sts< sw<"
