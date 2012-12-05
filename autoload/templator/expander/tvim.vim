" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2012-12-05.
" @Revision:    49


" if !exists('g:templator#expander#tvim#use_sandbox')
"     let g:templator#expander#tvim#use_sandbox = 1   "{{{2
" endif


function! templator#expander#tvim#Init() "{{{3
    return 1
endf


function! templator#expander#tvim#Expand() "{{{3
    let text = join(getline(1, '$'), "\n")
    let text = substitute(text, '<?vim\_s\+\(\_.\{-}\)\_s*?>', '\=s:Replace(submatch(1))', 'g')
    " TLogVAR text
    let lines = split(text, '\|\n')
    1,$delete
    call append(1, lines)
    1delete
    if search('<?vimcursor?>', 'cw')
        let line = substitute(getline('.'), '<?vimcursor?>', '', '')
        call setline('.', line)
    endif
endf


function! s:Replace(code) "{{{3
    " TLogVAR a:code
    let lines = split(a:code, '\n')
    let lines = map(lines, '":". v:val')
    let t = @t
    try
        let @t  = join(lines, "\n") ."\n"
        " TLogVAR @t
        redir => output
        " if g:templator#expander#tvim#use_sandbox && (
        "             \ !exists('b:templator_args') ||
        "             \ get(b:templator_args, 'use_sandbox', g:templator#expander#tvim#use_sandbox))
        "     silent sandbox @t
        " else
            silent @t
        " endif
        redir END
    finally
        let @t = t
    endtry
    let output = substitute(output, '^\n\|\n$', '', '')
    " let output = substitute(output, '\n', "\<c-j>", 'g')
    " TLogVAR output
    return output
endf


