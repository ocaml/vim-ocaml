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

syn spell toplevel

syn case match

syn include @odocSyntaxOCaml syntax/ocaml.vim
unlet b:current_syntax

syn cluster odocInline contains=odocBold,odocItalic,odocEmphasis,odocMiscInline,odocList,odocLinkText,odocUrl,odocCrossref,odocCode,odocCodeBlock,odocVerbatim,odocTargetSpecific,odocTag,odocEscaped,odocEscapedError,odocBraceError,odocTagError

syn match odocBraceError "[{}]"

syn region odocLinkText transparent matchgroup=odocMarker start="{\%({[!:]\)\@=" end="}" contains=odocUrl,odocCrossref,@Spell,@odocInline
syn region odocUrl matchgroup=odocUrlMarker start="{:\_s*" end="\_s*}"
" a bit leniant with ":"
syn match odocCrossrefKw contained "\<\%(!modules\|module\%(-type\)\?\|class\%(-type\)\?\|val\|type\|exception\|method\|constructor\|extension\|extension-decl\|field\|instance-variable\|section\|page\)[-:]"
syn match odocCrossrefKwDeprecated contained "\<\%(modtype\|classtype\|value\|exn\|const\|label\)[-:]"
syn region odocCrossref matchgroup=odocCrossrefMarker start="{!" end="}" contains=odocCrossrefKw,odocCrossrefKwDeprecated

syn region odocBold matchgroup=odocMarker start="{b\>" end="}" contains=@Spell,@odocInline
syn region odocEmphasis matchgroup=odocMarker start="{e\>" end="}" contains=@Spell,@odocInline
syn region odocItalic matchgroup=odocMarker start="{i\>" end="}" contains=@Spell,@odocInline
syn region odocMiscInline matchgroup=odocMarker start="{[CLR^_]" end="}" contains=@Spell,@odocInline
syn region odocVerbatim matchgroup=odocMarker start="{v\>" end="\<v}"

syn region odocTargetSpecific matchgroup=odocUnknownTarget start="{%.\{-}:\|{%" end="%}"

if get(g:,'odoc_html_support',0)
  syn include @odocHtml syntax/html.vim
  unlet b:current_syntax
  syn region odocTargetSpecific matchgroup=odocMarker start="{%html:" end="%}" contains=@odocHtml
else
  syn region odocTargetSpecific matchgroup=odocMarker start="{%html:" end="%}" contains=@Spell
endif

syn region odocDyckWord contained transparent start="{" end="}" contains=odocDyckWord
syn region odocTargetSpecific matchgroup=odocMarker start="{m\%(ath\)\?\>" end="}" contains=odocDyckWord
syn region odocTargetSpecific matchgroup=odocMarker start="{%\%(latex\|texi\|man\):" end="%}"
syn region odocHeading start="{[0-5]\%(\s\|$\|:\)\@=" end="}" contains=@Spell,odocHeadingLabel
syn match odocHeadingLabel contained "\%({[0-5]\)\@<=:[^ \t:]*"
syn region odocTable transparent matchgroup=odocMarker start="{t\>" end="}" contains=@Spell,@odocInline
syn region odocTable transparent matchgroup=odocMarker start="{table\>" end="}" contains=odocTableRow
syn region odocTableRow transparent matchgroup=odocMarker start="{tr\>"  end="}" contains=odocTableEntry contained
syn region odocTableEntry transparent matchgroup=odocMarker start="{t[dh]\>"  end="}" contains=@Spell,@odocInline contained
syn match odocEscapedBracket contained "\\[][]"
syn region odocBalancedBracket contained transparent start="\[" end="]"
syn region odocCode matchgroup=odocMarker start="\[" end="\]" contains=odocBalancedBracket,odocEscapedBracket
syn region odocCodeBlock matchgroup=odocMarker start="{@[^\[]\+\[" end="\]}"
syn region odocCodeBlock matchgroup=odocMarker start="{\%(@ocaml\%(\_s[^\[]*\)\?\)\?\[" end="\]}" contains=@odocSyntaxOCaml
syn match odocListMarker "^\s*[-+]\s"
syn region odocListItem contained transparent matchgroup=odocListMarker start="{\%(-\|li\>\)" end="}" contains=@Spell,@odocInline
syn region odocList transparent matchgroup=odocListMarker start="{[ou]l\>" end="}" contains=odocListItem
syn match odocTagError "@[a-zA-Z]*"
syn match odocTag "@\%(author\|deprecated\|param\|raises\?\|returns\?\|see\|since\|before\|version\|open\|closed\|inline\|canonical\)\>"

syn match odocEscapedError "\\."
syn match odocEscaped "\\[][{}@\\]"

" Shamelessly borrowed from HTML syntax
hi def odocBold     term=bold cterm=bold gui=bold
hi def odocEmphasis term=underline cterm=underline gui=underline
hi def odocItalic   term=italic cterm=italic gui=italic

hi def link odocUrlMarker odocMarker
hi def link odocUrl Underlined
hi def link odocCrossrefMarker odocCrossref    " or odocMarker
hi def link odocCrossref Label
hi def link odocCrossrefKw Keyword
hi def link odocCrossrefKwDeprecated Keyword   " we may highlight it differently
hi def link odocHeading Title
hi def link odocHeadingLabel Label
hi def link odocListMarker Operator
hi def link odocMarker Delimiter
hi def link odocTag Keyword

hi def link odocBraceError Error
hi def link odocUnknownTarget Error
hi def link odocTagError Error
hi def link odocEscapedError Error
hi def link odocEscaped SpecialChar
hi def link odocEscapedBracket odocEscaped

let b:current_syntax = "odoc"

unlet odoc_syntax_loading

let &cpo = s:keepcpo
unlet s:keepcpo

" vim: ts=8
