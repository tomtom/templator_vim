" @Author:      <?vimeval b:templator_args["user"]?>
" @Website:     <?vimeval b:templator_args["homepage"]?>
" @License:     <?vimeval b:templator_args["license"]?>
" @Revision:    0

au BufRead,BufNewFile *<?vimeval get(b:templator_args, "suffix", b:templator_args["1"])?> set filetype=<?vimeval b:templator_args["1"]?>

