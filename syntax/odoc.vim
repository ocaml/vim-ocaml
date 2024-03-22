" Vim syntax file
" Language:     Odoc/OCamldoc
" Filenames:    *.mld
" Maintainers:  Samuel Hym
"               Nicolas Osborne
" URL:          https://github.com/ocaml/vim-ocaml
" Last Change:
"               2024 Jan 26 - initial version

" Quit when a syntax file was already loaded
if !exists("odoc_syntax_loading")
  if exists("b:current_syntax")
    finish
  endif
  let odoc_syntax_loading = 1
endif

let s:keepcpo = &cpo
set cpo&vim

syn case match

syn include @odocSyntaxOCaml syntax/ocaml.vim
unlet b:current_syntax

syn cluster odocInline contains=odocBold,odocItalic,odocEmphasis,odocMiscInline,odocList,odocLink,odocCode,odocCrossref,odocCodeBlock,odocVerbatim,odocTargetSpecific,odocTag

syn region odocLink matchgroup=odocLinkMarker start="{" end="}" contains=odocCrossref
syn region odocBold matchgroup=odocMarker start="{b\>" end="}" contains=@Spell,@odocInline
syn region odocEmphasis matchgroup=odocMarker start="{e\>" end="}" contains=@Spell,@odocInline
syn region odocItalic matchgroup=odocMarker start="{i\>" end="}" contains=@Spell,@odocInline
syn region odocMiscInline matchgroup=odocMarker start="{[CLR^_]" end="}" contains=@Spell,@odocInline
syn region odocVerbatim matchgroup=odocMarker start="{v\>" end="\<v}"

if get(g:,'odoc_html_support',0)
  syn include @odocHtml syntax/html.vim
  unlet b:current_syntax
  syn region odocTargetSpecific matchgroup=odocMarker start="{%html:" end="%}" contains=@odocHtml
else
  syn region odocTargetSpecific matchgroup=odocMarker start="{%html:" end="%}" contains=@Spell
endif

syn region odocDyckWord contained start="{" end="}" contains=odocDyckWord
syn region odocTargetSpecific matchgroup=odocMarker start="{m\%(ath\)\?\>" end="}" contains=odocDyckWord
syn region odocTargetSpecific matchgroup=odocMarker start="{%\%(latex\|texi\|man\):" end="%}" contains=@Spell
syn region odocHeading start="{[0-5]" end="}" contains=@Spell
syn region odocTable matchgroup=odocMarker start="{t\>" end="}" contains=@Spell,@odocInline
syn region odocTable matchgroup=odocMarker start="{table\>" end="}" contains=odocTableRow
syn region odocTableRow matchgroup=odocMarker start="{tr\>"  end="}" contains=odocTableEntry
syn region odocTableEntry matchgroup=odocMarker start="{t[dh]\>"  end="}" contains=@Spell,@odocInline
syn region odocCode matchgroup=odocMarker start="\[" end="\]"
syn region odocCodeBlock matchgroup=odocMarker start="{@[^\[]\+\[" end="\]}"
syn region odocCodeBlock matchgroup=odocMarker start="{\%(@ocaml\%(\s[^\[]*\)\?\)\?\[" end="\]}" contains=@odocSyntaxOCaml
syn match odocListMarker "^\s*[-+]\s"
syn region odocListItem contained matchgroup=odocListMarker start="{\%(-\|li\>\)" end="}" contains=@Spell,@odocInline
syn region odocList matchgroup=odocListMarker start="{[ou]l\>" end="}" contains=odocListItem
" a bit leniant with ":"
syn match odocCrossrefKw contained "\<\%(module\%(-type\)\?\|class\%(-type\)\?\|val\|type\|exception\|method\|constructor\|extension\|field\|instance-variable\|section\|page\)[-:]"
syn region odocCrossref start="{!" end="}" contains=odocCrossrefKw
syn match odocTag "@\%(author\|deprecated\|param\|raise\|return\|see\|since\|before\|version\)"

" Shamelessly borrowed from HTML syntax
hi def odocBold     term=bold cterm=bold gui=bold
hi def odocEmphasis term=bold,underline cterm=bold,underline gui=bold,underline
hi def odocItalic   term=italic cterm=italic gui=italic

hi def link odocCrossref Float
hi def link odocCrossrefKw Keyword
hi def link odocHeading Title
hi def link odocLink Underlined
hi def link odocListMarker Operator
hi def link odocMarker Delimiter
hi def link odocTag Keyword

let b:current_syntax = "odoc"

unlet odoc_syntax_loading

let &cpo = s:keepcpo
unlet s:keepcpo

" vim: ts=8
