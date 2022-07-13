" opam.vim - Switch ocaml versions from inside Vim
" Maintainer:   Rudi Grinberg <http://rgrinberg.com>
" Version:      1.0

if exists('g:loaded_opam') || v:version < 700 || &cp
  finish
endif

let g:loaded_opam = 1

" Utility {{{1

function! opam#eval_env()
  let opam_eval = system("opam env --readonly")
  let cmds = split(opam_eval, "\n")
  for cmd in cmds
    let var = split(split(cmd, ";")[0], "=")
    execute 'let $' . var[0] . " = " . var[1]
  endfor
  let g:opam_current_compiler = opam#compiler_version()
endfunction

function! opam#switch(ocaml_version)
  let res = system('opam switch --color=never ' . s:shellesc(a:ocaml_version))
  let success = empty(matchstr(res, 'ERROR'))
  if success
    call opam#eval_env()
  endif
  return success
endfunction

function! opam#chomp(s)
  return substitute(a:s, '\n', '', 'g')
endfunction

function! opam#compiler_version()
  return opam#chomp(system("opam switch show"))
endfunction

function! s:shellesc(arg) abort
  if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  else
    return shellescape(a:arg)
  endif
endfunction

" }}}1
" :Opam {{{1

function! opam#cmd_switch(version)
  let success = opam#switch(a:version)
  if success
    echomsg "Using " . g:opam_current_compiler
  else
    echoerr "Switching to " . a:version . " failed"
  endif
endfunction

function! s:Opam(bang,...) abort
  if len(a:000) > 1
    if a:1 ==# "switch"
      call opam#cmd_switch(a:2)
    else
      echoerr "Only switching is supported for now"
    end
  elseif len(a:000) > 0
    call opam#cmd_switch(a:1)
  else
    call opam#eval_env()
    echomsg "Using " . g:opam_current_compiler
  end
endfunction

function! s:Complete(A,L,P)
  let switches = split((system("opam switch --short 2> /dev/null")), "\n")
  call map(switches, 'opam#chomp(v:val)')
  return join(switches, "\n")
endfunction

command! -bar -nargs=* -complete=custom,s:Complete Opam :call s:Opam(<bang>0,<f-args>)

" }}}1
" Statusline {{{1

function! opam#statusline()
  if exists('g:opam_current_compiler')
    let c = g:opam_current_compiler
  else
    let c = opam#compiler_version()
  endif
  return substitute('['.c.']','^\[\]$','','')
endfunction

function! opam#statusline_ft_ocaml()
  if &filetype ==# 'ocaml'
    return opam#statusline()
  else
    return ''
  endif
endfunction

" }}}1

" vim:set sw=2 sts=2:
