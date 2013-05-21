" @Author:      <?vimeval b:templator_args["user"]?>
" @Website:     <?vimeval b:templator_args["homepage"]?>
" @License:     <?vimeval b:templator_args["license"]?>
" @Revision:    0
" GetLatestVimScripts: <?vimeval get(b:templator_args, 'script_id', 0)?> 0 :AutoInstall: <?vimeval b:templator_args["1"]?>.vim

if &cp || exists("loaded_<?vimeval b:templator_args["1"]?>")
    finish
endif
let loaded_<?vimeval b:templator_args["1"]?> = 1

let s:save_cpo = &cpo
set cpo&vim


<?vimcursor?>


let &cpo = s:save_cpo
unlet s:save_cpo
