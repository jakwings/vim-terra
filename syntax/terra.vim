" Vim syntax file
" Language:     Terra
" Maintainer:   Jak Wings
" Last Change:  2016 October 19

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


let s:terra_executable = exists('g:terra_executable') ? g:terra_executable : 'terra'
let s:terra_is_executable = executable(s:terra_executable)
let s:script_dir = expand('<sfile>:p:h:h') . '/scripts'
let s:script_prg = shellescape(s:terra_executable) . ' '

syn case match
syn sync match terraSync grouphere NONE @\v^\s*%(function|terra|local|global|var)>@

if s:terra_is_executable
  let s:cmd = s:script_prg . shellescape(s:script_dir . '/terra_predefined.t')
  call execute(split(system(s:cmd), "\n"))
else
" Predefined Variables {
syn match   terraPredefined     @\v<Strict%(\_s*\.\_s*%(strict))?>@
syn match   terraPredefined     @\v<_G>@
syn match   terraPredefined     @\v<_VERSION>@
syn match   terraPredefined     @\v<arg>@
syn match   terraPredefined     @\v<array>@
syn match   terraPredefined     @\v<arrayof>@
syn match   terraPredefined     @\v<assert>@
syn match   terraPredefined     @\v<bit%(\_s*\.\_s*%(arshift|band|bnot|bor|bswap|bxor|lshift|rol|ror|rshift|tobit|tohex))?>@
syn match   terraPredefined     @\v<collectgarbage>@
syn match   terraPredefined     @\v<constant>@
syn match   terraPredefined     @\v<coroutine%(\_s*\.\_s*%(create|resume|running|status|wrap|yield))?>@
syn match   terraPredefined     @\v<debug%(\_s*\.\_s*%(debug|getfenv|gethook|getinfo|getlocal|getmetatable|getregistry|getupvalue|setfenv|sethook|setlocal|setmetatable|setupvalue|traceback|upvalueid|upvaluejoin))?>@
syn match   terraPredefined     @\v<dofile>@
syn match   terraPredefined     @\v<error>@
syn match   terraPredefined     @\v<gcinfo>@
syn match   terraPredefined     @\v<getfenv>@
syn match   terraPredefined     @\v<getmetatable>@
syn match   terraPredefined     @\v<global>@
syn match   terraPredefined     @\v<io%(\_s*\.\_s*%(close|flush|input|lines|open|output|popen|read|stderr|stdin|stdout|tmpfile|type|write))?>@
syn match   terraPredefined     @\v<ipairs>@
syn match   terraPredefined     @\v<jit%(\_s*\.\_s*%(arch|attach|flush|off|on|opt|os|status|util|version|version_num))?>@
syn match   terraPredefined     @\v<jit\_s*\.\_s*opt%(\_s*\.\_s*%(start))>@
syn match   terraPredefined     @\v<jit\_s*\.\_s*util%(\_s*\.\_s*%(funcbc|funcinfo|funck|funcuvname|ircalladdr|traceexitstub|traceinfo|traceir|tracek|tracemc|tracesnap))>@
syn match   terraPredefined     @\v<label>@
syn match   terraPredefined     @\v<load>@
syn match   terraPredefined     @\v<loadfile>@
syn match   terraPredefined     @\v<loadstring>@
syn match   terraPredefined     @\v<macro>@
syn match   terraPredefined     @\v<math%(\_s*\.\_s*%(abs|acos|asin|atan|atan2|ceil|cos|cosh|deg|exp|floor|fmod|frexp|huge|ldexp|log|log10|max|min|mod|modf|pi|pow|rad|random|randomseed|sin|sinh|sqrt|tan|tanh))?>@
syn match   terraPredefined     @\v<module>@
syn match   terraPredefined     @\v<newproxy>@
syn match   terraPredefined     @\v<next>@
syn match   terraPredefined     @\v<operator>@
syn match   terraPredefined     @\v<os%(\_s*\.\_s*%(clock|date|difftime|execute|exit|getenv|remove|rename|setlocale|time|tmpname))?>@
syn match   terraPredefined     @\v<package%(\_s*\.\_s*%(config|cpath|loaded|loaders|loadlib|path|preload|searchpath|seeall|terrapath))?>@
syn match   terraPredefined     @\v<package\_s*\.\_s*loaded%(\_s*\.\_s*%(_G|asdl|bit|coroutine|debug|ffi|io|jit|math|os|package|string|table))>@
syn match   terraPredefined     @\v<package\_s*\.\_s*preload%(\_s*\.\_s*%(ffi))>@
syn match   terraPredefined     @\v<pairs>@
syn match   terraPredefined     @\v<pcall>@
syn match   terraPredefined     @\v<print>@
syn match   terraPredefined     @\v<rawequal>@
syn match   terraPredefined     @\v<rawget>@
syn match   terraPredefined     @\v<rawset>@
syn match   terraPredefined     @\v<require>@
syn match   terraPredefined     @\v<select>@
syn match   terraPredefined     @\v<setfenv>@
syn match   terraPredefined     @\v<setmetatable>@
syn match   terraPredefined     @\v<sizeof>@
syn match   terraPredefined     @\v<string%(\_s*\.\_s*%(byte|char|dump|find|format|gfind|gmatch|gsub|len|lower|match|rep|reverse|sub|upper))?>@
syn match   terraPredefined     @\v<symbol>@
syn match   terraPredefined     @\v<table%(\_s*\.\_s*%(concat|foreach|foreachi|getn|insert|maxn|remove|sort))?>@
syn match   terraPredefined     @\v<terralib%(\_s*\.\_s*%(LineInfo|SymbolInfo|_trees|anonfunction|anonstruct|asm|attrload|attrstore|backtrace|bindtoluaapi|cast|compilationunitaddvalue|constant|createmacro|cudahome|cudalibpaths|currenttimeinseconds|debuginfo|defineobjects|definequote|diagnostics|disas|disassemble|dumpmodule|environment|externfunction|freecompilationunit|freetarget|fulltrace|gcdebug|global|importlanguage|includec|includecstring|includepath|initcompilationunit|initdebugfns|inittarget|internalmacro|intrinsic|irtypes|isconstant|isdebug|isfunction|isglobalvar|isintegral|islabel|islist|ismacro|isoverloadedfunction|isquote|israwlist|issymbol|istarget|istree|isverbose|jit|jitcompilationunit|kinds|languageextension|linklibrary|linklibraryimpl|linkllvm|linkllvmimpl|linkllvmstring|llvm_gcdebugmetatable|llvmsizeof|llvmversion|load|loadfile|loadstring|lookupline|lookupsymbol|macro|makeenv|memoize|nativetarget|new|newanchor|newcompilationunit|newdiagnostics|newenvironment|newlabel|newlist|newquote|newsymbol|newtarget|offsetof|overloadedfunction|pointertolightuserdata|printraw|registercfile|registerinternalizedfiles|runlanguage|saveobj|saveobjimpl|select|sizeof|systemincludes|target|terrahome|traceback|type|typeof|types|unimportlanguages|unpackstruct|unpacktuple))?>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*cudalibpaths%(\_s*\.\_s*%(driver|nvvm|runtime))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*diagnostics%(\_s*\.\_s*%(finishandabortiferrors|haserrors|reporterror|source))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*environment%(\_s*\.\_s*%(combinedenv|enterblock|leaveblock|localenv|luaenv))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*irtypes%(\_s*\.\_s*%(checks|definitions|list|listcache|members|namespaces|optional|uniquelist))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*jitcompilationunit%(\_s*\.\_s*%(collectfunctions|llvm_cu|symbols))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*kinds%(\_s*\.\_s*%(allocvar|and|apply|array|arrayconstructor|assignment|attrload|attrstore|block|breakstat|cast|constant|constructor|debuginfo|defer|float|fornum|functiondef|functionextern|functype|globalvalueref|globalvariable|gotostat|ifstat|index|inlineasm|integer|label|letin|literal|logical|niltype|not|opaque|operator|or|pointer|primitive|repeatstat|returnstat|select|setter|sizeof|struct|structcast|terrafunction|var|vector|vectorconstructor|whilestat))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*languageextension%(\_s*\.\_s*%(default|eof|name|number|string|tokenkindtotoken|tokentype))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*macro%(\_s*\.\_s*%(run))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*nativetarget%(\_s*\.\_s*%(cnametostruct|llvm_target))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*newlist%(\_s*\.\_s*%(concat|foreach|foreachi|getn|insert|insertall|isclassof|map|maxn|remove|sort))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*target%(\_s*\.\_s*%(getorcreatecstruct))>@
syn match   terraPredefined     @\v<terralib\_s*\.\_s*types%(\_s*\.\_s*%(array|bool|ctypetoterra|double|error|float|funcpointer|functype|int|int16|int32|int64|int8|intptr|istype|long|newstruct|newstructwithanchor|niltype|opaque|placeholderfunction|pointer|ptrdiff|rawstring|tuple|uint|uint16|uint32|uint64|uint8|unit|vector))>@
syn match   terraPredefined     @\v<tonumber>@
syn match   terraPredefined     @\v<tostring>@
syn match   terraPredefined     @\v<tuple>@
syn match   terraPredefined     @\v<type>@
syn match   terraPredefined     @\v<unpack>@
syn match   terraPredefined     @\v<unpackstruct>@
syn match   terraPredefined     @\v<unpacktuple>@
syn match   terraPredefined     @\v<vector>@
syn match   terraPredefined     @\v<vectorof>@
syn match   terraPredefined     @\v<xpcall>@
hi def link terraPredefined     Identifier
" Predefined Variables }
endif

syn match   terraErrNumber      @\w\+@ contained
hi def link terraErrNumber      Error

syn match   terraIntegerSuffix  @\v\c%(ul?l?|ll?)@ contained nextgroup=terraErrNumber
hi def link terraIntegerSuffix  Number
syn match   terraInteger        @\v<\d+@ nextgroup=terraIntegerSuffix,terraErrNumber
syn match   terraInteger        @\v<0[xX]\x+@ nextgroup=terraIntegerSuffix,terraErrNumber
hi def link terraInteger        Number

syn match   terraFloatSuffix    @f@ contained nextgroup=terraErrNumber
hi def link terraFloatSuffix    Float
syn match   terraFloat          @\v<\d+f@ nextgroup=terraErrNumber
syn match   terraFloat          @\v<\d+\.%(\d+)?%([eE][-+]?\d+)?@ nextgroup=terraFloatSuffix,terraErrNumber
syn match   terraFloat          @\v<\d+[eE][-+]?\d+@ nextgroup=terraFloatSuffix,terraErrNumber
syn match   terraFloat          @\v\.\d+%([eE][-+]?\d+)?@ nextgroup=terraFloatSuffix,terraErrNumber
hi def link terraFloat          Float

syn match   terraIdentifier     /\v(::\_s*)@<=\i+%(\_s*[:.]\_s*\i+)*(\_s*::)@=/
syn match   terraIdentifier     /\v(<%(function|terra)>\_s+)@<=\i+%(\_s*[:.]\_s*\i+)*/
syn match   terraIdentifier     /\v(<%(local|global|var)>\_s+%(\i+%(\_s*:\_s*\i+)?\_s*,\_s*)*)@<=\i+/
hi def link terraIdentifier     Identifier

syn match   terraOperator       /#\|\.\.\|==\|\~=\|>=\|<=\|<<\|>>\|->\|[,.:=+\-*\/%^<>&@]/
syn keyword terraOperator       and or not 
hi def link terraOperator       Operator

syn match   terraSymbol         @\v\.{3}|::|`@
hi def link terraSymbol         Special

" NO HIGHLIGHT
syn match   terraBracket        @[([{}\])]@

syn keyword terraStatement      break defer do else elseif end escape for function global goto if import in local quote repeat return struct terra then union until var while
hi def link terraStatement      Statement

syn keyword terraBoolean        false true
hi def link terraBoolean        Boolean

syn keyword terraNull           nil
hi def link terraNull           Constant

if s:terra_is_executable
  let s:cmd = s:script_prg . shellescape(s:script_dir . '/terra_type.t')
  call execute(split(system(s:cmd), "\n"))
else
" Builtin Types {
syn keyword terraType           bool double float int int16 int32 int64 int8 intptr long niltype opaque ptrdiff rawstring uint uint16 uint32 uint64 uint8
syn match   terraType           @\v<terralib\_s*\.\_s*types\_s*\.\_s*%(error|placeholderfunction|unit)>@
hi def link terraType           Type
" Builtin Types }
endif

syn match   terraErrEscape      @\\.\?@ contained
hi def link terraErrEscape      Error
syn match   terraEscape         @\v\\%([abfnrtvz"'\\]|x\x\x|\d{1,3})@ contained
hi def link terraEscape         SpecialChar

syn region  terraString         matchgroup=terraStringX start=@"@ skip=@\\.@ end=@"@ contains=terraEscape,terraErrEscape
syn region  terraString         matchgroup=terraStringX start=@'@ skip=@\\.@ end=@'@ contains=terraEscape,terraErrEscape
hi def link terraString         String
syn region  terraStringBlock    matchgroup=terraStringBlockX start=@\[\z(=*\)\[@ end=@\]\z1]@
hi def link terraStringBlock    String

syn keyword terraCommentOuch    XXX contained
hi def link terraCommentOuch    Underlined
syn keyword terraCommentDamn    FIXME contained
hi def link terraCommentDamn    Error
syn keyword terraCommentTodo    TODO contained
hi def link terraCommentTodo    Todo
syn cluster terraCommentNote    contains=terraCommentTodo,terraCommentDamn,terraCommentOuch

syn match   terraComment        @\%^#!.*$@
syn match   terraComment        @--.*$@ contains=@terraCommentNote,terraCommentX
hi def link terraComment        Comment
syn region  terraCommentBlock   matchgroup=terraCommentBlockX start=@--\[\z(=*\)\[@ end=@\]\z1\]@ contains=@terraCommentNote
hi def link terraCommentBlock   Comment

" for indent check
syn match   terraCommentX       @--\ze.*$@ contained transparent
hi def link terraCommentBlockX  Comment
hi def link terraStringX        String
hi def link terraStringBlockX   String


let &cpo = s:cpo_save
unlet s:cpo_save

let b:current_syntax = 'terra'
