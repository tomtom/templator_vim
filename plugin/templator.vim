" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2010-09-26.
" @Revision:    9
" GetLatestVimScripts: 0 0 :AutoInstall: templator.vim
" Project templates using skeleton/snippets engines

if &cp || exists("loaded_templator")
    finish
endif
let loaded_templator = 1

let s:save_cpo = &cpo
set cpo&vim


" :display: Templator [DIRNAME/]NAME
" NAME is the basename (with the extension removed) of a multi-files 
" project template.
command! -complete=customlist,templator#Complete -nargs=1 Templator call templator#Setup(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
