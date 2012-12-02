" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-12-02.
" @Last Change: 2010-09-26.
" @Revision:    16



SpecBegin 'title': 'Place holders'
            \, 'sfile': 'autoload/templator.vim'


It should parse argument lists.
Should be equal <SID>ParseArgs(['foo']), {'0': 'foo'}
Should be equal <SID>ParseArgs(['foo', 'foo=bar', 'bar']), {'0': 'foo', '1': 'bar', 'foo': 'bar'}


It should expand filenames.
Should be equal <SID>ExpandFilename(
            \ 'la%%%{foo}la%{0}la%{1}la',
            \ <SID>ParseArgs(['foo', 'foo=bar', 'bar'])),
            \ 'la%barlafoolabarla'
Should be equal <SID>ExpandFilename(
            \ 'la%%%{f:XY}la%{0}la%{1}la',
            \ <SID>ParseArgs(['foo', 'foo=bar', 'bar'])),
            \ 'la%XYlafoolabarla'


