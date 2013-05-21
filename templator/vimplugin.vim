" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2012-12-13.
" @Revision:   29

" :doc:
"                                                     *templator-vimplugin*
" VIM Plugin Template Set~
" 
" This template set serves as an example for how to use templator.
" 
" Run with:
" 
"     :Templator [*][PATH/]vimplugin NAME
" 
" The first argument is the name of the plugin. The name is used 
" in several locations in the template files.
" 
" Users should define the following variables in |vimrc| before using this 
" template set:
" 
"     g:templator_vimplugin_user
"     g:templator_vimplugin_homepage
"     g:templator_vimplugin_license


if !exists('g:templator_vimplugin_user')
    let g:templator_vimplugin_user = $USER
endif

if !exists('g:templator_vimplugin_homepage')
    let g:templator_vimplugin_homepage = 'http://www.vim.org'
endif

if !exists('g:templator_vimplugin_license')
    let g:templator_vimplugin_license = 'GPL2 or later (see http://www.gnu.org/licenses/gpl.html)'
endif


function! g:templator#hooks.vimplugin.CheckArgs(args) dict
    if !has_key(a:args, '1')
        echohl WarningMsg
        echom "VIM Plugin: Require at least one argument: the plugin name"
        echohl NONE
        return 0
    endif
    let a:args.user = g:templator_vimplugin_user
    let a:args.license = g:templator_vimplugin_license
    let a:args.homepage = g:templator_vimplugin_homepage
    return 1
endf


