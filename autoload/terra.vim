" Vim plugin file
" Language:     Terra
" Maintainer:   Jak Wings
" Last Change:  2016 September 21

if exists('b:did_autoload')
  finish
endif

" TODO: Make sure echomsg is off for release.
let s:cpo_save = &cpo
set cpo&vim


"let s:skip1 = '<SID>InCommentOrLiteral(line("."), col("."))'
let s:skip2 = '<SID>InLiteral(line("."), col(".")) || <SID>InComment(line("."), col(".")) == 1'
let s:skip3 = '!<SID>InKeyword(line("."), col("."))'
let s:skip4 = '!<SID>InBracket(line("."), col("."))'
let s:cfstart = '\v<%(function|terra|if|while|for|quote|escape|repeat)>'
let s:cfmiddle = '\v<%(then|elseif|else|do|in)>|\|'
let s:cfend = '\v<%(end|until)>'
let s:bstartp = '\v<%(if|while|for|quote|escape|then|elseif|else|do|in|repeat)>'

function! terra#Indent()
  if v:lnum <= 1
    return 0
  endif

  call cursor(v:lnum, 1)
  let l:pnzpos = searchpos('.', 'cbnW')
  if l:pnzpos == [0, 0]
    return 0
  endif

  if s:InComment2(l:pnzpos) > 1
    let [l:n, l:i] = [col([v:lnum, '$']) - 1, 1]
    while l:i <= l:n
      if !s:InComment2(v:lnum, l:i)
        if getline(v:lnum) =~# '^\s*\]=*\]'
          "echomsg 'Comment' (l:pnzpos[0] . '-' . v:lnum) 0
          return 0
        else
          break
        endif
      endif
      let l:i += 1
    endwhile
    "echomsg 'Comment' (l:pnzpos[0] . '-' . v:lnum) -1
    return -1
  endif

  if s:InLiteral2(l:pnzpos)
    "echomsg 'String' (l:pnzpos[0] . '-' . v:lnum) -1
    return -1
  endif

  unlet! l:pnzpos

  " NOTE: Lines started in comments and strings are checked already.

  let l:pnblnum = s:PrevNonblank(v:lnum - 1)
  if l:pnblnum < 1
    return 0
  endif

  let l:pnbline = getline(l:pnblnum)
  let l:pnbindent = indent(l:pnblnum)

  let l:line = getline(v:lnum)
  let l:indent = l:pnbindent
  let l:shiftwidth = shiftwidth()

  let l:continuing = 0
  " If the previous line ends with a unary or binary operator,
  if s:IsContinued(l:pnblnum)
    let l:continuing = 1
    let l:contlnum = l:pnblnum
    let l:ppcontinued = 0
    let l:ppnblnum = s:PrevNonblank(l:pnblnum - 1)
    while s:IsContinued(l:ppnblnum)
      let l:ppcontinued += 1
      let l:contlnum = l:ppnblnum
      let l:ppnblnum = s:PrevNonblank(l:ppnblnum - 1)
    endwhile
    "echomsg 'Continued1' l:pnblnum l:contlnum
    " If the previous line is also continuing another line,
    if l:ppcontinued
      " keep using the previous indent.
      "echomsg 'Continuing1' (l:pnblnum . '-' . v:lnum) l:pnbindent
      let l:indent = l:pnbindent
    else
      " indent this line twice as far.
      "echomsg 'Continuing2' (l:pnblnum . '-' . v:lnum) (l:pnbindent + l:shiftwidth * 2)
      let l:indent = l:pnbindent + l:shiftwidth * 2
    endif

    unlet! l:contlnum l:ppnblnum l:ppcontinued
  endif

  " If the previous line contains an unmatched opening bracket
  if !l:continuing && l:pnbline =~# '[(\[{]'
    " if the line ends with an opening bracket,
    if l:pnbline =~# '[(\[{]\s*$' && !s:InCommentOrLiteral(l:pnblnum, col([l:pnblnum, '$']) - 1)
      " indent this line.
      let l:indent += l:shiftwidth
    else
      " find the unmatched opening bracket,
      " NOTE: The cursor must not be at an matched closing bracket.
      "  | ( (()) //(
      "        ^^----- not at these places
      let l:start = [0, 0]
      let l:end = col([l:pnblnum, '$']) - 1
      call cursor(l:pnblnum, l:end)
      while l:end > 0
        let l:start = s:OuterPos(l:start, searchpairpos('(', '', ')', 'bnW', s:skip4, l:pnblnum))
        let l:start = s:OuterPos(l:start, searchpairpos('\[', '', '\]', 'bnW', s:skip4, l:pnblnum))
        let l:start = s:OuterPos(l:start, searchpairpos('{', '', '}', 'bnW', s:skip4, l:pnblnum))
        if l:start == [0, 0]
          break
        endif
        " find the matched closing bracket on the same line,
        call cursor(l:start[0], l:start[1])
        let l:c = s:CharAtCursor(l:start[0], l:start[1])
        if searchpair(escape(l:c, '['), '', escape(tr(l:c, '([{', ')]}'), ']'),
              \ 'znW', s:skip4, l:pnblnum) < 1
          " the unmatched opening bracket is found,
          break
        endif
        let l:start = [0, 0]
        let l:end = l:start[1]
      endwhile
      if l:start != [0, 0]
        " indent this line.
        "echomsg 'Open bracket' (l:pnblnum . '-' . v:lnum) (l:indent + l:shiftwidth)
        let l:indent += l:shiftwidth
      endif
    endif

    unlet! l:start l:end l:c
  endif

  " If there is a matched closing bracket on the previous line,
  " NOTE:
  " >|[
  "  |  (1 -
  "  |      1) * 2]
  "  |  command
  "   ^
  if !l:continuing
    call cursor(l:pnblnum, 1)
    " find the last closing bracket,
    let l:end = [0, 0]
    let l:end = s:OuterPos(l:end, searchpairpos('(', '', ')', 'zncr', s:skip4, l:pnblnum))
    let l:end = s:OuterPos(l:end, searchpairpos('\[', '', '\]', 'zncr', s:skip4, l:pnblnum))
    let l:end = s:OuterPos(l:end, searchpairpos('{', '', '}', 'zncr', s:skip4, l:pnblnum))
    if l:end != [0, 0]
      " find the matched opening bracket on another line,
      let l:c = s:CharAtCursor(l:end[0], l:end[1])
      let l:start = searchpairpos(escape(tr(l:c, ')]}', '([{'), '['), '', escape(l:c, ']'), 'nbW', s:skip4)
      if l:start[0] != l:end[0]
        " and then this line has the same indent as the line the matched bracket stays.
        "echomsg 'Matched bracket' (l:start[0] . '-' . v:lnum) indent(l:start[0])
        let l:indent = indent(l:start[0])
      endif
    endif

    unlet! l:start l:end l:c
  endif

  " If there is a matched closing bracket on this line,
  " NOTE:
  "  |[
  " >|  (1 -
  "  |      1) * 2
  "  |]
  "   ^     ^
  if l:line =~# '^\s*[)\]}]'
    " find the first closing bracket,
    call cursor(v:lnum, 1)
    let l:end = [0, 0]
    let l:end = s:InnerPos(l:end, searchpairpos('(', '', ')', 'zncW', s:skip4, v:lnum))
    let l:end = s:InnerPos(l:end, searchpairpos('\[', '', '\]', 'zncW', s:skip4, v:lnum))
    let l:end = s:InnerPos(l:end, searchpairpos('{', '', '}', 'zncW', s:skip4, v:lnum))
    if l:end != [0, 0]
      " find the matched opening bracket on another line,
      let l:c = s:CharAtCursor(l:end[0], l:end[1])
      let l:start = searchpairpos(escape(tr(l:c, ')]}', '([{'), '['), '', escape(l:c, ']'), 'nbW', s:skip4)
      if l:start[0] != l:end[0]
        " and then this line has the same indent as the line the matched bracket stays.
        "echomsg 'Closing Bracket' (l:start[0] . '-' . v:lnum) indent(l:start[0])
        let l:indent = indent(l:start[0])
      endif
    endif

    unlet! l:start l:end l:c
  endif

  " If this line ends (part of) a control flow,
  call cursor(v:lnum, 1)
  if l:line =~# '\v^\s*%(end|elseif|else|then|in|do|rpeat)>'
    " find the start or middle of the control block,
    let l:start = searchpairpos(s:cfstart, s:cfmiddle, s:cfend, 'bnW', s:skip3)
    if l:start != [0, 0]
      " then this line has the same indent as the start.
      "echomsg 'Block end' (l:start[0] . '-' . v:lnum) indent(l:start[0])
      return indent(l:start[0])
    endif

    unlet! l:start
  endif

  " If the previous line starts a function definition,
  if l:pnbline =~# '\v^\s*%(%(local|global|return)\s+)?%(function|terra)>'
    " indent this line further.
    return l:pnbindent + l:shiftwidth
  endif

  " If the previous line starts (part of) a control flow,
  call cursor(l:pnblnum, 1)
  while 1
    " find the start of the control block,
    let l:start = searchpos(s:bstartp, 'zcepW', l:pnblnum)
    if l:start[2] == 0
      break
    endif
    if !s:InKeyword(l:start[0:1])
      call cursor(l:pnblnum, l:start[1] + 3)
      continue
    endif
    let l:index = l:start[2]
    " find the end of the control block on the same line,
    let l:end = searchpair(s:cfstart, '', s:cfend, 'znW', s:skip3, l:pnblnum)
    " if the control block is not ended,
    if l:end < 1
      " then indent this line further.
      if !s:IsContinued(l:pnblnum)
        "echomsg 'Block start' (l:pnblnum . '-' . v:lnum) (l:pnbindent + l:shiftwidth)
        return l:pnbindent + l:shiftwidth
      else
        "echomsg 'Block start' (l:pnblnum . '-' . v:lnum) (l:pnbindent + l:shiftwidth * 2)
        return l:pnbindent + l:shiftwidth * 2
      endif
    endif
  endwhile

  unlet! l:start l:end l:index

  return l:indent
endfunction

function! s:PrevNonblank(lnum)
  let l:lnum = prevnonblank(a:lnum)
  while l:lnum > 0 && (s:InComment2(l:lnum, 1) || s:InLiteral2(l:lnum, 1))
    let l:lnum = prevnonblank(l:lnum - 1)
  endwhile
  return l:lnum
endfunction

" NOTE:
"     v
"  |1 + --[[ comment ]]
"  |2
function! s:IsContinued(lnum)
  let l:lnum = s:PrevNonblank(a:lnum)
  if l:lnum < 1
    return 0
  endif
  let l:line = getline(l:lnum)
  let l:width = strwidth(substitute(l:line, '\s*$', '', ''))
  " FIXME?
  "  | 1 + --
  "  | --
  "  |     2
  return !s:InCommentOrLiteral(a:lnum, l:width)
        \ && (l:line =~# '\v<%(and|or|not)\s*$'
        \ || l:line =~# '\%(#\|\.\.\|==\|\~=\|>=\|<=\|<<\|>>\|->\|[,.:=+\-*\/%^<>&@]\)\s*$'
        \ )
endfunction

function! s:InCommentOrLiteral(...)
  return call('s:InComment', a:000) || call('s:InLiteral', a:000)
endfunction

function! s:InKeyword(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  for id in s:Or(synstack(l:lnum, l:col), [])
    if synIDattr(id, 'name') ==# 'terraStatement'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:InBracket(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  for id in s:Or(synstack(l:lnum, l:col), [])
    if synIDattr(id, 'name') ==# 'terraBracket'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:InComment(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  let l:stack = synstack(l:lnum, l:col)
  let l:i = len(l:stack)
  while l:i > 0
    let l:sname = synIDattr(l:stack[l:i - 1], 'name')
    if l:sname =~# '^terraCommentBlockX\?$'
      return 2
    elseif l:sname =~# '^terraCommentX\?$'
      return 1
    endif
    let l:i -= 1
  endwhile
  return 0
endfunction

function! s:InLiteral(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  for id in s:Or(synstack(l:lnum, l:col), [])
    let l:sname = synIDattr(id, 'name')
    if l:sname =~# '^terraStringBlockX\?$'
      return 2
    elseif l:sname =~# '^terraStringX\?$'
      return 1
    endif
  endfor
  return 0
endfunction

" NOTE:
" |-- --inside
"    ^^^^^^^^^
" |--[[ *inside ]]
"      ^^^^^^^^^
function! s:InComment2(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  let l:stack = synstack(l:lnum, l:col)
  let l:i = len(l:stack)
  while l:i > 0
    let l:sname = synIDattr(l:stack[l:i - 1], 'name')
    if l:sname ==# 'terraCommentBlock'
      return 2
    elseif l:sname ==# 'terraComment'
      return 1
    elseif l:sname =~# '\v^terraComment%(Block)?X$'
      return 0
    endif
    let l:i -= 1
  endwhile
  return 0
endfunction

" NOTE:
" |"inside"
"   ^^^^^^
" |[[ inside ]]
"    ^^^^^^^^
function! s:InLiteral2(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  let l:stack = synstack(l:lnum, l:col)
  let l:i = len(l:stack)
  while l:i > 0
    let l:sname = synIDattr(l:stack[l:i - 1], 'name')
    if l:sname ==# 'terraStringBlock'
      return 2
    elseif l:sname ==# 'terraString'
      return 1
    elseif l:sname =~# '\v^terraString%(Block)?X$'
      return 0
    endif
    let l:i -= 1
  endwhile
  return 0
endfunction

function! s:CharAtCursor(...)
  let [l:lnum, l:col] = (type(a:1) == type([]) ? a:1 : a:000)
  return matchstr(getline(l:lnum), '\%' . l:col . 'c.')
endfunction

function! s:Or(x, y)
  return !empty(a:x) ? a:x : a:y
endfunction

function! s:InnerPos(x, y)
  if a:x == [0, 0]
    return a:y
  elseif a:y == [0, 0]
    return a:x
  else
    return a:x[1] < a:y[1] ? a:x : a:y
  end
endfunction

function! s:OuterPos(x, y)
  if a:x == [0, 0]
    return a:y
  elseif a:y == [0, 0]
    return a:x
  else
    return a:x[1] > a:y[1] ? a:x : a:y
  end
endfunction

function! terra#MatchSkip()
  let l:pos = getcurpos()[1:2]
  return s:InComment2(l:pos) || s:InLiteral2(l:pos)
endfunction


let &cpo = s:cpo_save
unlet s:cpo_save

let b:did_autoload = 1
