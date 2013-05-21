" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2012-12-06.
" @Revision:    70

" :doc:
"                                                   *templator-tvim*
" Template vim~
"
" tvim is a minimal php-style template engine. The following 
" place-holders are supported:
"
"   <?vim ... ?> ... Replace the placeholder with the output (see 
"                    |:echo|) of the enclosed vim code.
"   <?vimeval ... ?> ... Replace the placeholder with the value (see 
"                    |eval()|) of the enclosed vim code.
"   <?vimcursor?> .. Set the cursor at this position after expanding any 
"                    placeholder.


if !exists('g:templator#expander#tvim#enable')
    " It true, enable templates in template-vim.
    "
    " Code embedded in templates is executed via |:@|. It is not run in 
    " the sandbox.
    let g:templator#expander#tvim#enable = 1   "{{{2
endif


function! templator#expander#tvim#Init() "{{{3
    return g:templator#expander#tvim#enable
endf


function! templator#expander#tvim#Expand() "{{{3
    let text = join(getline(1, '$'), "\n")
    " TLogVAR 1, text
    let text = substitute(text, '<?\(vim\(eval\)\?\)\_s\+\(\(\_[^''"?]\+\|''\_[^'']*''\|"\([^"]*\n\|\_[^"]*"\)\)\{-}\)\_s*?>', '\=s:Replace(submatch(1), submatch(3))', 'g')
    " TLogVAR 2, text
    let lines = split(text, '\|\n')
    1,$delete
    call append(1, lines)
    1delete
    if search('<?vimcursor?>', 'cw')
        let line = substitute(getline('.'), '<?vimcursor?>', '', '')
        call setline('.', line)
    endif
endf


function! s:Replace(type, code) "{{{3
    " TLogVAR a:type, a:code
    if a:type == 'vimeval'
        let output = eval(a:code)
    else
        let lines = split(a:code, '\n')
        let lines = map(lines, '":". v:val')
        let t = @t
        try
            let @t  = join(lines, "\n") ."\n"
            let output = ''
            " TLogVAR @t
            redir =>> output
            silent @t
            redir END
        finally
            let @t = t
        endtry
        let output = substitute(output, '^\n\|\n$', '', '')
        " let output = substitute(output, '\n', "\<c-j>", 'g')
    endif
    " TLogVAR output
    return output
endf


