" Vim indent file
" Language:     Terra
" Maintainer:   Jak Wings
" Last Change:  2016 October 12

if exists('b:did_indent')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


setlocal nolisp
setlocal nocindent
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=terra#Indent()
setlocal indentkeys=!^F,o,O,0=end,0=then,0=else,0=in,0=do,0=until,0=]],0=]=],0=]==],0=]===],0=),0=],0=}
setlocal cinkeys=!^F,o,O,0=end,0=then,0=else,0=in,0=do,0=until,0=]],0=]=],0=]==],0=]===],0=),0=],0=}
setlocal cinwords=function,terra,if,while,for,repeat,then,elseif,else,do,struct,union,quote,escape,local\ function,local\ terra,global\ function,global\ terra,return\ function,return\ terra
let b:undo_indent = 'set lisp< cindent< autoindent< smartindent< indentexpr< indentkeys< cinkeys< cinwords<'


let &cpo = s:cpo_save
unlet s:cpo_save

let b:did_indent = 1
