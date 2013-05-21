" @Author:      <?vimeval b:templator_args["user"]?>
" @Website:     <?vimeval b:templator_args["homepage"]?>
" @License:     <?vimeval b:templator_args["license"]?>
" @Revision:    0

if exists("b:current_syntax")
  finish
endif
let s:keepcpo= &cpo
set cpo&vim


<?vimcursor?>


if version >= 508
  if version < 508
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " HiLink

  delcommand HiLink
endif


let b:current_syntax = "<?vimeval b:templator_args['1']?>"
let &cpo = s:keepcpo
unlet s:keepcpo
