" @Author:      <?vimeval b:templator_args["user"]?>
" @Website:     <?vimeval b:templator_args["homepage"]?>
" @License:     <?vimeval b:templator_args["license"]?>
" @Revision:    0
" GetLatestVimScripts: <?vimeval get(b:templator_args, 'script_id', 0)?> 0 :AutoInstall: <?vimeval b:templator_args["1"]?>.vim

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" if exists('&ofu')
"     setlocal omnifunc=
" endif
" setlocal comments=
" setlocal commentstring=

<?vimcursor?>

" let b:undo_ftplugin =

let &cpo = s:cpo_save
unlet s:cpo_save
