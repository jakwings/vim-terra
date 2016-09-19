" Vim filetype plugin file
" Language:     Terra
" Maintainer:   Jak Wings
" Last Change:  2016 September 17

if exists('b:did_ftplugin')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


setlocal comments=s:--[[,m:\ ,e:]],f:--
setlocal commentstring=--%s
setlocal formatoptions-=t fo+=c fo+=r fo+=o fo+=q fo+=l fo+=j

setlocal path=
setlocal includeexpr=
setlocal include=\\v^\\s*import>
setlocal define=\\v^\\s*%(function\|terra\|local\|global\|var)>
setlocal isident=@,48-57,_
setlocal iskeyword=@,48-57,_
setlocal suffixesadd=.t
setlocal matchpairs=(:),{:},[:]

let b:match_ignorecase = 0
let b:match_skip = 's:Comment\|String'
let b:match_words = '\v<%(function|terra|if|while|for|quote|escape)>\m:\v<%(then|elseif|else|do|in)>|\|\m:\<end\>,\<repeat\>:\<until\>,--\[\[:\]\],--\[=\[:\]=\],--\[==\[:\]==\],--\[===\[:\]===\],\[\[:\]\]\zs,\[=\[:\]=\]\zs,\[==\[:\]==\]\zs,\[===\[:\]===\]\zs,(:),\[:\],{:}'
source $VIMRUNTIME/macros/matchit.vim


let &cpo = s:cpo_save
unlet s:cpo_save

let b:did_ftplugin = 1
