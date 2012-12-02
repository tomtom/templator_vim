" templator.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-12-02.
" @Last Change: 2010-09-26.
" @Revision:    140


if !exists('g:templator#expanders')
    " A dictionary of with the following structure:
    "     {"TYPE_NAME": {
    "         'check': "EXPRESSION"
    "         'expander': "COMMAND"
    "     }}
    "
    " The check EXPRESSION is |eval()|uated in order to check if a 
    " template expander is available.
    "
    " The expander COMMAND is |:execute|d in order to expand a file 
    " templates place holders. The vim expression is run in the 
    " destination file's buffer that contains template markup.
    " :read: let g:templator#expanders = {...}   "{{{2
    let g:templator#expanders = {
                \ 'tskel': {
                \     'check': 'exists(":TSkeletonSetup")',
                \     'expander': 'call tskeleton#FillIn("", &filetype)'
                \ }
                \ }
endif


function! s:GetDriverFiles() "{{{3
    if !exists('s:templators')
        let files = globpath(&rtp, 'templator/*.*')
        let s:templators = {}
        for dirname in split(files, '\n')
            if isdirectory(dirname)
                let tname = fnamemodify(dirname, ':t:r')
                let ttype = fnamemodify(dirname, ':e')
                if has_key(g:templator#expanders, ttype)
                    let checker = get(g:templator#expanders[ttype], 'check', '')
                    if empty(checker) || eval(checker)
                        if has_key(s:templators, tname)
                            echohl WarningMsg
                            echom "Templator: duplicate entry:" tname filename
                            echohl NONE
                        endif
                        let dirname_len = len(dirname)
                        let filenames = split(glob(dirname .'/**/*'), '\n')
                        let filenames = filter(filenames, '!isdirectory(v:val)')
                        let s:templators[tname] = {
                                    \ 'type': ttype,
                                    \ 'dir': dirname,
                                    \ 'files': filenames
                                    \ }
                    endif
                endif
            endif
        endfor
    endif
    return s:templators
endf


function! templator#Complete(ArgLead, CmdLine, CursorPos) "{{{3
    let templators = keys(s:GetDriverFiles())
    " TLogVAR templators
    let dir = fnamemodify(a:ArgLead, ':h')
    let base = fnamemodify(a:ArgLead, ':t')
    let templators = filter(templators, 'strpart(v:val, 0, len(a:ArgLead)) ==# base')
    if empty(templators)
        let completions = split(glob(a:ArgLead .'*'), '\n')
    else
        let completions = map(templators, 'dir ."/". v:val')
    endif
    " TLogVAR completions
    return completions
endf


function! templator#Setup(name, ...) "{{{3
    let args = s:ParseArgs(a:000)
    let dirname = fnamemodify(a:name, ':h')
    if !isdirectory(dirname)
        call mkdir(dirname, 'p')
    endif
    let fulldirname = fnamemodify(dirname, ':p')
    " TLogVAR dirname
    let drvname = fnamemodify(a:name, ':t')
    " TLogVAR drvname
    let templators = s:GetDriverFiles()
    if !has_key(templators, drvname)
        throw "Templator: Unknown template name: ". drvname
    endif
    let templator = templators[drvname]
    let drvtype = templator.type
    " TLogVAR drvtype
    if !has_key(g:templator#expanders, drvtype)
        throw printf("Templator: Unknown template type %s for %s", drvtype, a:name)
    else
        let expander = g:templator#expanders[drvtype].expander
        " TLogVAR expander
    endif
    let cwd = getcwd()
    try
        " TLogVAR templator.dir
        let driver_file = fnamemodify(templator.dir, ':p:r') .'.vim'
        if !filereadable(driver_file)
            let driver_file = ''
        endif
        let templator_dir_len = len(templator.dir) + 1
        if templator.dir =~ '[\/]$'
            let templator_dir_len += 1
        endif
        for filename in templator.files
            call s:SetDir(fulldirname)
            " TLogVAR filename
            let subdir = strpart(fnamemodify(filename, ':h'), templator_dir_len)
            " TLogVAR subdir
            let subfilename = s:ExpandFilename(fnamemodify(filename, ':t'), args)
            " TLogVAR subfilename
            let outdir = dirname
            if !empty(subdir)
                if outdir == '.'
                    let outdir = subdir
                else
                    let outdir .= '/'. subdir
                endif
            endif
            " TLogVAR outdir
            if outdir == '.'
                let outfile = subfilename
            else
                if !isdirectory(outdir)
                    call mkdir(outdir, 'p')
                endif
                let outfile = outdir .'/'. subfilename
            endif
            " TLogVAR outfile
            if filereadable(outfile)
                echohl WarningMsg
                echom "Templator: File already exists: Ignore it:" outfile
                echohl NONE
            else
                let lines = readfile(filename)
                if writefile(lines, outfile) != -1
                    exec 'edit' fnameescape(outfile)
                    exec expander
                    update
                endif
            endif
        endfor
        if !empty(driver_file)
            call s:SetDir(fulldirname)
            exec 'source' fnameescape(driver_file)
        endif
    finally
        exec 'cd' fnameescape(cwd)
    endtry
endf


function! s:SetDir(dirname) "{{{3
    if getcwd() != a:dirname
        " echom "DBG" 'cd' fnameescape(fulldirname)
        exec 'cd' fnameescape(a:dirname)
    endif
endf


function! s:ExpandFilename(filename, args) "{{{3
    let filename = substitute(a:filename, '%\(%\|{\(\w\+\)\%(:\(.\{-}\)\)\?}\)', '\=s:PlaceHolder(a:args, submatch(1), submatch(2), submatch(3))', 'g')
    return filename
endf


function! s:PlaceHolder(args, pct, name, default) "{{{3
    if a:pct == '%'
        return '%'
    else
        return get(a:args, a:name, a:default)
    endif
endf


function! s:ParseArgs(arglist) "{{{3
    let args = {}
    let idx = 0
    for arg in a:arglist
        if arg =~ '^\w\+='
            let key = matchstr(arg, '^\w\{-}\ze=')
            let val = matchstr(arg, '^\w\{-}=\zs.*$')
        else
            let key = idx
            let val = arg
            let idx += 1
        endif
        let args[key] = val
    endfor
    return args
endf


