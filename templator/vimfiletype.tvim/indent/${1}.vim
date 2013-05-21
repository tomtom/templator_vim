" @Author:      <?vimeval b:templator_args["user"]?>
" @Website:     <?vimeval b:templator_args["homepage"]?>
" @License:     <?vimeval b:templator_args["license"]?>
" @Revision:    0

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

<?vimcursor?>

" setlocal autoindent
" setlocal indentexpr=
" setlocal cindent
" setlocal cinoptions+=

" let b:undo_indent = ""
