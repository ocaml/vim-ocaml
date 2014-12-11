if exists("b:current_syntax")
  finish
endif

" need %{vars}%
" env: [[CAML_LD_LIBRARY_PATH = "%{lib}%/stublibs"]]
syn keyword opamKeyword1 build remove depends depopts conflicts env packages patches version maintainer tags license homepage authors doc install author available
syn match opamKeyword2 "\v(bug-reports|post-messages|ocaml-version|opam-version|dev-repo)"

syn keyword opamTodo FIXME NOTE NOTES TODO XXX contained
syn match opamComment "#.*$" contains=opamTodo,@Spell
syn match opamOperator ">\|<\|=\|<=\|>="

syn region opamInterpolate start=/%{/ end=/}%/ contained
syn region opamString start=/"/ end=/"/ contains=opamInterpolate
syn region opamSeq start=/\[/ end=/\]/ contains=ALLBUT,opamKeyword
syn region opamExp start=/{/ end=/}/ contains=ALLBUT,opamKeyword

hi link opamKeyword1 Keyword
hi link opamKeyword2 Keyword

hi link opamString String
hi link opamExp Function
hi link opamSeq Statement
hi link opamOperator Operator
hi link opamComment Comment
hi link opamInterpolate Identifier

let b:current_syntax = "opam"

" vim: ts=2 sw=2
