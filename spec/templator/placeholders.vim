" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-12-02.
" @Last Change: 2012-12-03.
" @Revision:    18



SpecBegin 'title': 'Place holders'
            \, 'sfile': 'autoload/templator.vim'


It should parse argument lists.
Should be equal <SID>ParseArgs(['foo']), {'1': 'foo'}
Should be equal <SID>ParseArgs(['foo', 'foo=bar', 'bar']), {'1': 'foo', '2': 'bar', 'foo': 'bar'}


It should expand filenames.
Should be equal <SID>ExpandFilename(
            \ 'la$$${foo}la${1}la${2}la',
            \ <SID>ParseArgs(['foo', 'foo=bar', 'bar'])),
            \ 'la$barlafoolabarla'
Should be equal <SID>ExpandFilename(
            \ 'la$$${f=XY}la${1}la${2}la',
            \ <SID>ParseArgs(['foo', 'foo=bar', 'bar'])),
            \ 'la$XYlafoolabarla'


