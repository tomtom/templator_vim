" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2012-12-05.
" @Revision:    270


if !exists('g:templator#verbose')
    " If true, show some warnings (e.g. when opening an already existing 
    " file that wasn't created by templator).
    let g:templator#verbose = 1   "{{{2
endif


if !exists('g:templator#drivers')
    " :nodoc:
    let g:templator#drivers = {}   "{{{2
endif


if !exists('g:templator#edit')
    " The command used for opening files.
    let g:templator#edit = 'hide edit'   "{{{2
endif


if !exists('g:templator#sep')
    let g:templator#sep = exists('+shellslash') && !&shellslash ? '\' : '/'    "{{{2
endif


let s:expanders_init = {}


" :nodoc:
function! templator#Complete(ArgLead, CmdLine, CursorPos) "{{{3
    let templators = keys(s:GetDriverFiles())
    " TLogVAR templators
    let dir = fnamemodify(a:ArgLead, ':h')
    let base = fnamemodify(a:ArgLead, ':t')
    let templators = filter(templators, 'strpart(v:val, 0, len(a:ArgLead)) ==# base')
    if empty(templators)
        let completions = split(glob(a:ArgLead .'*'), '\n')
    else
        let completions = map(templators, 's:JoinFilename(dir, v:val)')
    endif
    " TLogVAR completions
    return completions
endf


" Create files based on the template set referred to by the basename of 
" the name argument.

" The name argument may contain directory information. E.g. 
" "foo/bar/test" will create file from the template set "test" in the 
" directory "foo/bar", which will be created if necessary.
"
"                                                     *b:templator_root_dir*
" If the name argument begins with "*", the filename is relative to the 
" project's root directory. Templator uses the following methods to find 
" the project's root directory:
"
"   1. If the variable b:templator_root_dir exists, use its value.
"   2. If tlib (vimscript #1863) is available, check if the current 
"      buffer is under the control of a supported VCS and use that 
"      directory.
"
" Additional arguments can be passed as a mix of numbered and named 
" arguments. E.g. "foo name=bar boo" will be parsed as:
"
"     1    = foo
"     name = bar
"     2    = boo
"
" Those arguments can be used from placeholders (see 
" |templator-placeholders|).
function! templator#Setup(name, ...) "{{{3
    let args = s:ParseArgs(a:000)
    let [tname, dirname] = s:GetDirname(a:name)
    " TLogVAR dirname
    let templator = s:GetTemplator(tname)
    let ttype = templator.type
    let cwd = getcwd()
    " TLogVAR cwd
    try
        " TLogVAR templator.dir
        let templator_dir_len = len(templator.dir) + 1
        if templator.dir =~ '[\/]$'
            let templator_dir_len += 1
        endif
        call s:Driver(dirname, tname, 'Before', args)
        for filename in templator.files
            call s:SetDir(dirname)
            " TLogVAR filename
            let outfile = s:GetOutfile(dirname, filename, args, templator_dir_len)
            if filereadable(outfile)
                if g:templator#verbose
                    echohl WarningMsg
                    echom "Templator: File already exists: " outfile
                    echohl NONE
                endif
                exec g:templator#edit fnameescape(outfile)
            else
                let lines = readfile(filename)
                if writefile(lines, outfile) != -1
                    let fargs = copy(args)
                    let fargs.filename = outfile
                    if !s:Driver('', tname, 'Edit', args)
                        exec g:templator#edit fnameescape(outfile)
                    endif
                    let b:templator_args = args
                    call templator#expander#{ttype}#Expand()
                    call s:Driver(&acd ? '' : expand('%:p:h'), tname, 'Buffer', args)
                    unlet! b:templator_args
                    update
                endif
            endif
        endfor
        call s:Driver(dirname, tname, 'After', args)
    finally
        exec 'cd' fnameescape(cwd)
    endtry
endf


function! s:GetDriverFiles() "{{{3
    if !exists('s:templators')
        let files = globpath(&rtp, 'templator/*.*')
        let s:templators = {}
        for dirname in split(files, '\n')
            if isdirectory(dirname)
                let tname = fnamemodify(dirname, ':t:r')
                let ttype = fnamemodify(dirname, ':e')
                " TLogVAR ttype, tname
                if !has_key(s:expanders_init, ttype)
                    try
                        let s:expanders_init[ttype] = templator#expander#{ttype}#Init()
                    catch /^Vim\%((\a\+)\)\=:E117/
                        let s:expanders_init[ttype] = 0
                    endtry
                endif
                " echom "DBG get(s:expanders_init, ttype, 0)" get(s:expanders_init, ttype, 0)
                if get(s:expanders_init, ttype, 0)
                    if has_key(s:templators, tname)
                        if g:templator#verbose
                            echohl WarningMsg
                            echom "Templator: duplicate entry:" tname filename
                            echohl NONE
                        endif
                    else
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


function! s:GetDirname(name) "{{{3
    " TLogVAR a:name
    let dirname = fnamemodify(a:name, ':p:h')
    let tname = fnamemodify(a:name, ':t')
    " TLogVAR tname
    if tname =~ '^\*'
        let tname = substitute(tname, '^\*', '', '')
        if exists('b:templator_root_dir')
            let dirname = s:JoinFilename(b:templator_root_dir, dirname)
        elseif exists('g:loaded_tlib') && g:loaded_tlib >= 100
            let [vcs_type, vcs_dir] = tlib#vcs#FindVCS(expand('%'))
            if !empty(vcs_dir)
                let dirname = fnamemodify(vcs_dir, ':p:h:h')
            endif
        endif
    endif
    if !isdirectory(dirname)
        call mkdir(dirname, 'p')
    endif
    " TLogVAR tname, dirname
    return [tname, dirname]
endf


function! s:GetTemplator(tname) "{{{3
    let templators = s:GetDriverFiles()
    if !has_key(templators, a:tname)
        throw "Templator: Unknown template name: ". a:tname
    endif
    let templator = templators[a:tname]
    let ttype = templator.type
    if !get(s:expanders_init, ttype, 0)
        throw printf("Templator: Unsupported template type %s for %s", ttype, a:name)
    endif
    if !has_key(g:templator#drivers, ttype)
        let g:templator#drivers[a:tname] = {}
        let driver_file = fnamemodify(templator.dir, ':p:h:r') .'.vim'
        " TLogVAR driver_file, filereadable(driver_file)
        if filereadable(driver_file)
            exec 'source' fnameescape(driver_file)
        endif
    endif
    return templator
endf


function! s:GetOutfile(dirname, filename, args, templator_dir_len) "{{{3
    " TLogVAR a:dirname, a:filename, a:args, a:templator_dir_len
    let subdir = strpart(fnamemodify(a:filename, ':h'), a:templator_dir_len)
    " TLogVAR subdir
    let subfilename = s:ExpandFilename(fnamemodify(a:filename, ':t'), a:args)
    " TLogVAR subfilename
    let outdir = a:dirname
    if !empty(subdir)
        if outdir == '.'
            let outdir = subdir
        else
            let outdir = s:JoinFilename(outdir, subdir)
        endif
    endif
    " TLogVAR outdir
    if outdir == '.'
        let outfile = subfilename
    else
        if !isdirectory(outdir)
            call mkdir(outdir, 'p')
        endif
        let outfile = s:JoinFilename(outdir, subfilename)
    endif
    " TLogVAR outfile
    return outfile
endf


function! s:Driver(dirname, tname, name, args, ...) "{{{3
    " TLogVAR a:dirname, a:tname, a:name, a:args
    let tdef = g:templator#drivers[a:tname]
    " TLogVAR tdef
    if has_key(tdef, a:name)
        if !empty(a:dirname)
            let cwd = getcwd()
        endif
        try
            call s:SetDir(a:dirname)
            " TLogVAR tdef[a:name]
            call tdef[a:name](a:args)
            return 1
        finally
            if !empty(a:dirname)
                exec 'cd' fnameescape(cwd)
            endif
        endtry
    endif
    return 0
endf


function! s:SetDir(dirname) "{{{3
    let dirname = s:StripSep(a:dirname)
    " TLogVAR dirname, getcwd()
    if !empty(dirname) && getcwd() != dirname
        exec 'cd' fnameescape(dirname)
    endif
endf


function! s:ExpandFilename(filename, args) "{{{3
    let filename = substitute(a:filename, '\$\(\$\|{\(\w\+\)\%(=\(.\{-}\)\)\?}\)', '\=s:PlaceHolder(a:args, submatch(1), submatch(2), submatch(3))', 'g')
    return filename
endf


function! s:PlaceHolder(args, pct, name, default) "{{{3
    if a:pct == '$'
        return '$'
    else
        return get(a:args, a:name, a:default)
    endif
endf


function! s:ParseArgs(arglist) "{{{3
    let args = {}
    let idx = 1
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


function! s:JoinFilename(...) "{{{3
    let parts = map(copy(a:000), 's:StripSep(v:val)')
    return join(parts, g:templator#sep)
endf


function! s:StripSep(filename) "{{{3
    return substitute(a:filename, '[\/]$', '', 'g')
endf

