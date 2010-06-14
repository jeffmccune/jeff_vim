" Jeff McCune's vimrc
" mccune.jeff@gmail.com
" 0xEFF on Twitter

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" JJM: Any changes to colorscheme will trigger this back on
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Show trailing whitepace and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Turn on search highlighting
set hlsearch

" Shift movement and selection Mac behavior.  Less vim like.
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
endif

" Filetype plugin and stuff
filetype plugin on
filetype indent on

if has("gui_running")
    " Turn off the menu bar.
    " set guioptions=egmrt
    "Set the font and size
    set guifont=Consolas:h18
    " Hide toolbar
    set guioptions-=T
endif

" Turn on spell checking with English dictionary
set spell
set spelllang=en
set spellsuggest=9 "show only 9 suggestions for misspelled words

" What's this do?
set wm=4

set nocompatible
set bs=2 "set backspace to be able to delete previous characters
" Enable line numbering, taking up 6 spaces
set number

" Turn off word wrapping
set wrap!

" Turn on smart indent
set smartindent
set tabstop=4 "set tab character to 4 characters
set expandtab "turn tabs into whitespace
set shiftwidth=4 "indent width for autoindent
filetype indent on "indent depends on filetype

" Turn on incremental search with ignore case (except explicit caps)
set incsearch
set ignorecase
set smartcase

" Informative status line
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

" Set color scheme
set t_Co=256
colorscheme desert256
syntax enable

" Enable indent folding
set foldenable
set fdm=indent

" Set space to toggle a fold
nnoremap <space> za

" Hide buffer when not in window (to prevent relogin with FTP edit)
set bufhidden=hide

" Have 3 lines of offset (or buffer) when scrolling
set scrolloff=3

" Enable balloon tooltips on spelling suggestions and folds
function! FoldSpellBalloon()
    let foldStart = foldclosed(v:beval_lnum )
    let foldEnd = foldclosedend(v:beval_lnum)
    let lines = []

    " Detect if we are in a fold
    if foldStart < 0
        " Detect if we are on a misspelled word
        let lines = spellsuggest( spellbadword(v:beval_text)[ 0 ], 5, 0 )
    else
        " we are in a fold
        let numLines = foldEnd – foldStart + 1
        " if we have too many lines in fold, show only the first 14
        " and the last 14 lines
        if ( numLines > 31 )
            let lines = getline( foldStart, foldStart + 14 )
            let lines += [ '-- Snipped ' . ( numLines - 30 ) . ' lines --' ]
            let lines += getline( foldEnd – 14, foldEnd )
        else
            " less than 30 lines, lets show all of them
            let lines = getline( foldStart, foldEnd )
        endif
    endif
    " return result
    return join( lines, has( “balloon_multiline" ) ? “\n" : " " )
endfunction

" set balloonexpr=FoldSpellBalloon()
" set ballooneval

