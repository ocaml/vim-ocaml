if exists("b:current_syntax")
    finish
endif

syntax keyword oasisKeyword Document Executable Flag Library Document Test

syntax match oasisKey "OASISFormat:"
syntax match oasisKey "OCamlVersion:"
syntax match oasisKey "Copyrights:"
syntax match oasisKey "Maintainers:"
syntax match oasisKey "XStdFilesAUTHORS:"
syntax match oasisKey "XStdFilesREADME:"
syntax match oasisKey "FindlibVersion:"
syntax match oasisKey "Name:"
syntax match oasisKey "Version:"
syntax match oasisKey "Synopsis:"
syntax match oasisKey "Authors:"
syntax match oasisKey "Homepage:"
syntax match oasisKey "License:"
syntax match oasisKey "BuildTools:"
syntax match oasisKey "Plugins:"
syntax match oasisKey "Description:"

syntax match oasisKey2 "\c\s\+Description\$\=:"
syntax match oasisKey2 "\c\s\+Pack\$\=:"
syntax match oasisKey2 "\c\s\+Default\$\=:"
syntax match oasisKey2 "\c\s\+Path\$\=:"
syntax match oasisKey2 "\c\s\+Findlibname\$\=:"
syntax match oasisKey2 "\c\s\+Modules\$\=:"
syntax match oasisKey2 "\c\s\+BuildDepends\$\=:"
syntax match oasisKey2 "\c\s\+MainIs\$\=:"
syntax match oasisKey2 "\c\s\+Install\$\=:"
syntax match oasisKey2 "\c\s\+Custom\$\=:"
syntax match oasisKey2 "\c\s\+InternalModules\$\=:"
syntax match oasisKey2 "\c\s\+Build\$\=:"
syntax match oasisKey2 "\c\s\+CompiledObject\$\=:"
syntax match oasisKey2 "\c\s\+Title\$\=:"
syntax match oasisKey2 "\c\s\+Type\$\=:"
syntax match oasisKey2 "\c\s\+FindlibParent\$\=:"
syntax match oasisKey2 "\c\s\+Command\$\=:"
syntax match oasisKey2 "\c\s\+Run\$\=:"
syntax match oasisKey2 "\c\s\+WorkingDirectory\$\=:"
syntax match oasisKey2 "\c\s\+BuildTools+:"
syntax match oasisKey2 "\c\s\+XOCamlbuildPath\$\=:"
syntax match oasisKey2 "\c\s\+XMETARequires\$\=:"
syntax match oasisKey2 "\c\s\+XMETADescription\$\=:"
syntax match oasisKey2 "\c\s\+InstallDir\$\=:"
syntax match oasisKey2 "\c\s\+AlphaFeatures\$\=:"
syntax match oasisKey2 "\c\s\+XOCamlbuildLibraries\$\=:"

highlight link oasisKeyword Keyword
highlight link oasisKey Identifier
highlight link oasisKey2 Function

let b:current_syntax = "oasis"
