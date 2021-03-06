" Jeff McCune's vimrc
" mccune.jeff@gmail.com
" 0xEFF on Twitter

" Swap dir for all so we don't litter
set directory=~/.vimswp

set nocompatible

" SnipMate plugin
filetype plugin on

" Find File plugin, quickly find a file
" FC .<CR> (Cache the directory)
" FF<CR> (Find File)
let g:FindFileIgnore = ['*.o', '*.pyc', '*/tmp/*', '*/.git/*']

" Add documentation for project plugin
helptags ~/.vim/doc

" Shift movement and selection Mac behavior.  Less vim like.
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
endif

" Filetype plugin and stuff
filetype plugin on
filetype indent on

if has("gui_running")
  "Set the font and size
  "set guifont=Consolas:h18
  set guifont=Source\ Code\ Pro\ for\ Powerline:h18
  " Hide toolbar
  set guioptions-=T
  " Hide the right scroll bar
  set guioptions-=r
endif

" Turn on spell checking with English dictionary
set spell
set spelllang=en
set spellsuggest=9 "show only 9 suggestions for misspelled words
" Selectively turn spelling off.
autocmd FileType c,cpp,lisp,puppet,ruby,vim setlocal nospell

set bs=2 "set backspace to be able to delete previous characters
" set wrapmargin (Generally unrecommended)
" set wm=4

" Turn on smart indent
set tabstop=2 "set tab character to 4 characters
set softtabstop=2
set expandtab "turn tabs into whitespace
set shiftwidth=2 "indent width for autoindent
" filetype indent on "indent depends on filetype
set smartindent

" Enable line numbering, taking up 6 spaces
set number

" Turn on word wrapping (Visually)
" set wrap

" Turn on search highlighting
set hlsearch
" Turn on incremental search with ignore case (except explicit caps)
set incsearch

" Make /-style searches case-sensitive only if there is a capital letter in
" the search expression. *-style searches continue to be consistently
" case-sensitive.
set ignorecase
set smartcase

" Informative status line
" set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]
"
" http://www.linux.com/archive/feature/120126
" [%{fugitive#statusline()}]
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}\ %{&fo}]\ [%l/%L,%v\ %p%%]\ [HEX=\%02.2B]
" set statusline=%F%m%r%h%w\ [TYPE=%Y]\ %{fugitive#statusline()}\ [%l/%L,%v\ %p%%]\ [HEX=\%02.2B]
" Always show the status line
set laststatus=2

"" 256 colors are disabled since we're using the custom solarized color palette
"" in iTerm2.
" set t_Co=256

" Set color scheme
" colorscheme desert256
" colorscheme slate
syntax enable
" Set g:solarized_termcolors=256 if the terminal emulator is not using the
" solarized palette.
" let g:solarized_termcolors=256
colorscheme solarized
set background=dark

" Enable indent folding
" JJM 2012-07-30 Disabled because I find myself expanding all folds anyway.
if version >= 702
  set foldenable
  set fdm=indent
end

" Set space to toggle a fold
nnoremap <space> za

" Allow Vim to manage multiple buffers
set hidden

" Have 3 lines of offset (or buffer) when scrolling
set scrolloff=3

" Visually select current indent level and greater.
" http://vim.wikia.com/wiki/VimTip1014
function! SelectIndent ()
  let temp_var=indent(line("."))
  while indent(line(".")-1) >= temp_var
    exe "normal k"
  endwhile
  exe "normal V"
  while indent(line(".")+1) >= temp_var
    exe "normal j"
  endwhile
endfun
" Map space to select the indent level
" nmap <space> :call SelectIndent()<CR>

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

" JJM FIXME E518: Unknown option: balloonexpr=FoldSpellBalloon()
" set balloonexpr=FoldSpellBalloon()
" set ballooneval

" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" Show trailing whitespace and spaces before a tab:
" match ExtraWhitespace /\s\+$\| \+\ze\t/
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" JJM: Any changes to colorscheme will trigger this back on
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen


highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

if version >= 702

  " Use :call clearmatches() to clear these matches.
  " Give an indicator when we approach col 80 (>72)
  " au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>72v', -1)
  " Give a strong indicator when we exceed col 80(>80)
  " au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  " Give an indicator of tailing white space.
  au BufWinEnter * let w:m3=matchadd('ErrorMsg', '\s\+$', -1)
  " Give an indicator of spaces before a tab.
  au BufWinEnter * let w:m4=matchadd('ErrorMsg', ' \+\ze\t', -1)
  " Give an indicator of tabs before a space.
  au BufWinEnter * let w:m5=matchadd('ErrorMsg', '\t\+\ze ', -1)
  " Just highlight all tabs.  They're annoying.
  au BufWinEnter * let w:m6=matchadd('ErrorMsg', '\t\+', -1)

end

" Allow vim comment commands
" http://vimdoc.sourceforge.net/htmldoc/options.html#modeline
set modeline
set modelines=7

" Quote a word consisting of letters from iskeyword.
nnoremap <silent> sd :call Quote('"')<CR>
nnoremap <silent> ss :call Quote("'")<CR>
nnoremap <silent> SS :call UnQuote()<CR>
function! Quote(quote)
  normal mz
  exe 's/\(\k*\%#\k*\)/' . a:quote . '\1' . a:quote . '/'
  normal `zl
endfunction

function! UnQuote()
  normal mz
  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
  normal `z
endfunction

" JJM Slight modification to surround the word with []'s
nnoremap <silent> qb :call Brace("[", "]")<CR>
function! Brace(left,right)
  normal mz
  exe 's/\(\k*\%#\k*\)/' . a:left . '\1' . a:right . '/'
  normal `zl
endfunction

" With a visual block selected, align =>'s
vmap <silent> . :Align =><CR>

function! AlignFats()
  let save_cursor = getpos(".")
  call SelectIndent()
  exe "norm ."
  call setpos('.', save_cursor)
  " Move the cursor back and forth to reset up/down properly.
  exe "norm h"
  exe "norm l"
endfun

function! StripTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

" Remap the personal modifier key (Defaults to '\')
let mapleader = ","
"" Map FuzzyFinder to <leader>f
"" 2012-01-31 JJM DISABLED IN PREFERENCE OF CTRLP
" map <leader>t :FufFile **/<CR>
"" Map Control-T to FuzzyFinder
" map <silent> <C-T> :FufFile **/<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/.git/*

" Map leader key (Set above), then a to Align Fats.
noremap <leader>a :call AlignFats()<CR>

" Map function keys to useful things
nmap <silent> <F1> :setlocal invnumber<CR>
nmap <silent> <F2> :setlocal invspell<CR>
nmap <silent> <F5> :FufBuffer<CR>

" Make file/command completion useful
set wildmode=list:longest

" Set the xterm title
set title

" Configure a longer history
set history=1000

" Syntastic Plugin (Automatic Syntax Checking)
" turns on chevrons in the gutter marking lines with syntax errors.
let g:syntastic_enable_signs=1
" automatically open a location list when a file is saved with syntax errors
let g:syntastic_auto_loc_list=1
" We typically use MRI
" let g:syntastic_ruby_checker="mri"

" Automatically reload files on changes.
" Useful for git rebasing and such
set autoread

" Make ctrlp ignore dotfiles and dotdirectories
let g:ctrlp_dotfiles = 0
" Open buffers only if they're in the current tab
let g:ctrlp_jump_to_buffer = 1
" Working directory is where .git lives
let g:ctrlp_working_path_mode = 2

let g:ctrlp_prompt_mappings = {
  \ 'PrtBS()':              ['<bs>', '<c-]>'],
  \ 'PrtDelete()':          ['<del>'],
  \ 'PrtDeleteWord()':      ['<c-w>'],
  \ 'PrtClear()':           ['<c-u>'],
  \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
  \ 'PrtHistory(-1)':       ['<c-n>'],
  \ 'PrtHistory(1)':        ['<c-p>'],
  \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
  \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
  \ 'AcceptSelection("t")': ['<c-t>', '<MiddleMouse>'],
  \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
  \ 'ToggleFocus()':        ['<s-tab>'],
  \ 'ToggleRegex()':        ['<c-r>'],
  \ 'ToggleByFname()':      ['<c-d>'],
  \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
  \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
  \ 'PrtExpandDir()':       ['<tab>'],
  \ 'PrtInsert("w")':       ['<F2>', '<insert>'],
  \ 'PrtInsert("s")':       ['<F3>'],
  \ 'PrtInsert("v")':       ['<F4>'],
  \ 'PrtInsert("+")':       ['<F6>'],
  \ 'PrtCurStart()':        ['<c-a>'],
  \ 'PrtCurEnd()':          ['<c-e>'],
  \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
  \ 'PrtCurRight()':        ['<c-l>', '<right>'],
  \ 'PrtClearCache()':      ['<F5>'],
  \ 'PrtDeleteMRU()':       ['<F7>'],
  \ 'CreateNewFile()':      ['<c-y>'],
  \ 'MarkToOpen()':         ['<c-z>'],
  \ 'OpenMulti()':          ['<c-o>'],
  \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
  \ }

" vim.ack
let g:ackprg="ack -H --nocolor --nogroup --column"

" Stolen from barn: https://gist.github.com/2839654
" Use ALT+SHIFT+[left|right]
" to navigate tabs in the various modes I'm likely to be in.
nnoremap <silent>^[[1;10C :tabnext<CR>
nnoremap <silent>^[[1;10D :tabprevious<CR>
inoremap <silent>^[[1;10C <ESC>:tabnext<CR>
inoremap <silent>^[[1;10D <ESC>:tabprevious<CR>
vnoremap <silent>^[[1;10C <ESC>:tabnext<CR>
vnoremap <silent>^[[1;10D <ESC>:tabprevious<CR>

" Map hotkeys to create or kill tabs
nnoremap <silent><leader>tn :tabnew<CR>
nnoremap <silent><leader>tk :tabclose<CR>

" From http://stackoverflow.com/questions/8354826/change-fugitives-gstatus-window-height
" Make the preview window bigger than a postage stamp
set previewheight=22

" Provide the ability to swap window splits
" From http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim
function! MarkWindowSwap()
  let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

" Terminal Hacking
" We need this to let autotest and watchr update the screen as we work in
" another buffer.  This allows us to leave the terminal buffer without
" switching it out of insert mode.
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_ReadUnfocused = 1

" Setup ruby-vim-conque to use rspec and not spec
let g:ruby_conque_rspec_runner='rspec'

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.  The cursor will
" jump to the location of the first error.  To jump back use the '' or ``
" key chords.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Map a :make to a command to make it easier to run.
map <Leader>j :RelatedSpecMake<CR>

nnoremap <silent> <C-r> :RelatedSpecVOpen<CR>
nnoremap <silent> ,<C-r> :RelatedSpecOpen<CR>

" Use rspec as the default compiler.  This will help with MakeGreen
autocmd BufNewFile,BufRead *.rb compiler rspec
autocmd BufNewFile,BufRead *_spec.rb compiler rspec
" Run the compiler when a spec file is written.  This should invoke the tests.
" autocmd BufWritePost *_spec.rb make! %
"

set encoding=utf-8

" Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

let g:Powerline_symbols = 'fancy'
let g:Powerline_stl_path_style = 'short'

" Set a highlight at column 80
set colorcolumn=80

" EOF
