" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2012-12-05.
" @Revision:   7


function! templator#expander#tskel#Init() "{{{3
    return exists(":TSkeletonSetup")
endf


function! templator#expander#tskel#Expand() "{{{3
    call tskeleton#FillIn("", &filetype)
endf

