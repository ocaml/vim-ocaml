" Language:    Menhir
" Maintainer:  vim-ocaml maintainers
" URL:         http://www.github.com/ocaml/vim-ocaml

if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/ocaml.vim
runtime! ftplugin/ocaml_*.vim ftplugin/ocaml/*.vim

" vim:sw=2 fdm=indent
