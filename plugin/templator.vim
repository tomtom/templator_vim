" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2010-09-26.
" @Revision:    18
" GetLatestVimScripts: 4345 0 :AutoInstall: templator.vim
" Project templates using skeleton/snippets engines

if &cp || exists("loaded_templator")
    finish
endif
let loaded_templator = 1

let s:save_cpo = &cpo
set cpo&vim


" :display: :Templator [DIRNAME/]NAME [ARG1 ARG2 ...]
" NAME is the basename (with the extension removed) of a multi-files 
" project template.
"
" The list of optional arguments is used to expand place holders in 
" filenames (see |templator-placeholders|).
"
" See |templator#Setup()| for details.
command! -complete=customlist,templator#Complete -nargs=+ Templator call templator#Setup(<f-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
