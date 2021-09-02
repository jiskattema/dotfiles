"{{{ Settings

" Enable syntax highlighting.
"
syntax on
let mapleader = "\\"

" Vim options.
"
set hidden                     " Allow hidden buffers
set scrolloff=5                " Keep space around the cursor line
set spelllang=en,nl            " default to English and Dutch
set thesaurus+=/home/jiska/.vim/thesaurus/english.txt

set autoindent                 " Indented text
set noautoread                 " Pick up external changes to files
set noautowrite                " Write files when navigating with :next/:previous
set background=dark            " Dark background by default
set backspace=indent,eol,start
set belloff=all                " Bells are annoying
set breakindent                " Wrap long lines *with* indentation
set breakindentopt=shift:2
set clipboard=unnamed,unnamedplus
set colorcolumn=81,82          " Highlight 81 and 82 columns                                                          
set conceallevel=0             " Always show text normally
set complete=.,w,b,u,t,i       " Sources for term and line completions
set completeopt=menu,menuone,noinsert,noselect
set dictionary=/usr/share/dict/words
set expandtab                  " Use spaces instead of tabs
set foldlevelstart=20
set foldmethod=indent          " Simple and fast
set formatoptions+=cqjnlro     " Default format options
set formatoptions-=tc
set history=200                " Keep 200 changes of undo history
set infercase                  " Smart casing when completing
set ignorecase                 " Search in case-insensitively
set noincsearch                " Dont go to search results immediately
set laststatus=0               " Dont need a statusline
set cmdheight=1                " More room for the status line
set matchtime=5                " blink matching brackets for 5 tenths of a second
set matchpairs=(:),{:},[:]
set mouse=""                   " No mouse support in the terminal
set mousehide                  " Hide mouse when typing text
set nobackup                   " No backup files
set nocompatible               " No Vi support
set noexrc                     " Disable reading of working directory vimrc files
set hlsearch                   " Don't highlight search results by default
set noshowmatch                " No jumping jumping cursors when matching pairs
set showmode                   " No to showing mode in bottom-left corner
set noswapfile                 " No backup files
set wrapscan                   " Don't wrap searches around
set nonumber                   " No line numbers
set path=**                    
set pumheight=20               " Height of complete list
set norelativenumber           " No relative numbers
set noruler                    " No ruler with column, row, percentage
set shiftwidth=2               " Default indentation amount
set shortmess+=c               " Don't show insert mode completion messages
set shortmess+=I               " Don't show intro message
set showmatch                  " show matching brackets
set signcolumn=number          " Render signs in the number column
set showbreak=↳                " Use this to wrap long lines
set smartcase                  " Case-smart searching
set smarttab                   " Tab at the start of line inserts blanks
set showtabline=0              " We dont need a tab line
set spelloptions=camel         " When spell checking, assume word boundaries include 'CamelCasing'.
set splitbelow                 " Split below current window
set splitright                 " Split window to the right
set tabstop=4                  " Tab width
set termguicolors              " Enable 24-bit color support for terminal Vim
set textwidth=80               " Standard width before breaking
set undodir^=~/.vim/undo//
set undofile                   " Maintain undo history
set updatetime=1000            " Certain plugins use this for CursorHold event triggering
set viminfo=                   " No backups
set wildcharm=<Tab>            " Defines the trigger for 'wildmenu' in mappings
set wildmenu                   " Nice command completions
set wildmode=longest,full      " Complete the next full match
set nowrap                     " Do not wrap long lines
set cryptmethod=blowfish2
set listchars=eol:$,tab:>-,trail:-
set nocursorline
set cursorlineopt=both         " line number and buffer line
set keywordprg=:DictPrg
" }}}

"{{{ Functions
function StylePrg()
  %y
  new
  normal p
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  %!style
endfunction

function! DictPrg(lookup)
  new
  execute 'silent read !dict -d english ' . a:lookup
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  normal gg
endfunction
command -nargs=1 DictPrg call DictPrg(<f-args>)

function! InsertZimHeader()
  let curr_date=strftime('%F', localtime())
  let curr_time=strftime('%T', localtime())
  let title=strftime('%A, %d. %B %Y', localtime())
  exec "normal! ggiContent-Type: text/x-zim-wiki\<CR>Wiki-Format: zim 0.4\<CR>Creation-Date: ".curr_date."T".curr_time."\<CR>\<CR>==== ".title." ====\<CR>" 
  set filetype=zimwiki
endfunction

function! PruneViminfo()
  " Dont read/write the jumplist to the .viminfo file
  clearjumps
endfunction

function AutoReplyCommand(pattern) abort
  let aliases =
    \ { 'cn' : 'cnext'
    \ , 'cp' : 'cprevious'
    \ , 'g'  : 'global'
    \ , 's'  : 'substitute'
    \ , 'v'  : 'vglobal'
    \ }

  " if the command is more complex, ie. has [], it will not be a valid pattern
  " for getcompletion. Luckily, we also do not need any autocommands then.
  if a:pattern =~ "["
    return ''
  endif

  if &ignorecase
    set noignorecase
    let completion = getcompletion(a:pattern, 'command')
    set ignorecase
  else
    let completion = getcompletion(a:pattern, 'command')
  endif

  let completion = len(completion) == 1 ? join(completion) : ''

  return get(aliases, a:pattern, completion)
endfunction
" }}}

"{{{ Mappings
nmap <Leader>a :ALEToggle<CR>
nmap <Leader>g :MagitOnly<CR>
nmap <Leader>d :SignifyDiff!<CR>
nmap <Leader>h :SignifyHunkDiff<CR>
nmap <Leader>s :SignifyToggle<CR>
nmap <silent><Leader>z :call InsertZimHeader()<CR>
nmap yoe :set invruler<CR>

" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>

" Navigate the jumplist with <M-i> instead of <C-i> with is Tab.
" I've configured my terminal to send <M-i> for when i press <C-i>
noremap i <C-i>
" }}}

"{{{ Plugins

" Vundle is changing the runtime paths. vim will need to re-scan and cache
" everything after vundle is finished.
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
  Plugin 'BlueCatMe/TempKeyword'
  Plugin 'dense-analysis/ale'
  Plugin 'jiskattema/new-moon.vim'
  Plugin 'joanrivera/vim-zimwiki-syntax'
  Plugin 'jreybert/vimagit'
  Plugin 'kana/vim-fakeclip'
  Plugin 'tmhedberg/SimpylFold'
  Plugin 'mhinz/vim-signify'
  Plugin 'michaeljsmith/vim-indent-object'
  Plugin 'natebosch/vim-lsc'
  Plugin 'skywind3000/vim-quickui'
  Plugin 'tommcdo/vim-ninja-feet'
  Plugin 'tpope/vim-characterize'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-speeddating'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-vinegar'
  Plugin 'wellle/targets.vim'
call vundle#end()

" Re-enable filetype auto-detection and have vim pickup vundle's changes
filetype plugin indent on

" Load up the match it plugin which provides smart % XML/HTML matching.
runtime macros/matchit.vim
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" Markdown
let g:markdown_folding = 1

" NetRW
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_preview = 1
let g:netrw_list_hide= netrw_gitignore#Hide().'\(^\|\s\s\)\zs\.\S\+'

" Signify
let g:signify_disable_by_default = 0

" ALE
let g:ale_disable_lsp = 1
let g:ale_set_signs = 0

" vim-lsc
let g:lsc_auto_map = v:true   " Use all the defaults

let g:lsc_server_commands = {
    \ 'python': 'pyls',
    \ }
" }}}

"{{{ Autocommands
autocmd VimLeavePre * call PruneViminfo()
autocmd VimEnter * call PruneViminfo()

augroup AutoReply
  autocmd!
  autocmd CmdlineLeave :
    \ execute 'silent doautocmd AutoReply User'
    \          AutoReplyCommand(getcmdline())

  autocmd User marks     call feedkeys(':normal!`', 'n')
  autocmd User oldfiles  call feedkeys(':edit#<',   'n')

  autocmd User buffers   call feedkeys(':buffer'      . "\<Space>",  'n')
  autocmd User files     call feedkeys(':buffer'      . "\<Space>",  'n')
  autocmd User ls        call feedkeys(':buffer'      . "\<Space>",  'n')

  autocmd User tabs      call feedkeys(':normal! gt'  . "\<S-Left>", 'n')

  autocmd User clist     call feedkeys(':silent cc'   . "\<Space>",  'n')
  autocmd User llist     call feedkeys(':silent ll'   . "\<Space>",  'n')
  autocmd User registers call feedkeys(':silent put'  . "\<Space>",  'n')
  autocmd User tags      call feedkeys(':tjump'       . "\<Space>",  'n')
  autocmd User undolist  call feedkeys(':silent undo' . "\<Space>",  'n')

  autocmd User changes   call feedkeys(':normal! g;'  . "\<S-Left>", 'n')
  autocmd User jumps     call feedkeys(':normal! '  . "\<S-Left>", 'n')

  autocmd User chistory
    \ if getqflist({'nr' : '$'}).nr > 1
    \ |   call feedkeys(':silent chistory | copen',  'n')
    \ |   call feedkeys("\<Home>\<S-Right>\<Right>", 'n')
    \ | endif
augroup END
" }}}

"{{{ Quick menu

call quickui#menu#reset()
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'papercol_dark'

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Plugins', [
     \ [ "&ALE toggle\t\\a", 'ALEToggle', 'Toggle automatic linting' ],
     \ ['--', '', '' ],
     \ [ "&Signify toggle\t\\s", 'SignifyToggle', 'Show linechanges in the gutter' ],
     \ [ "&Diff file\t\\d", 'SignifyDiff', 'Show diff in diff mode' ],
     \ [ "Diff &hunk\t\\h", 'SignifyHunkDiff', 'Show diff in a popup' ],
     \ ['--',''],
     \ [ "&Git\t\\g", 'execute "normal \\g"', 'Open Magit window' ],
     \ ['--','', '' ],
     \ [ "&Clear keywords\t\\ca", 'call clearmatches()', 'Set keywords using \\#' ],
     \ ['--', '', ''],
     \ ['Text stat&istics', 'call StylePrg()', 'runs GNU style on the current buffer' ],
     \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Options", [
     \ [ "&Paste\tyop", 'set invpaste'],
     \ [ "&Wrap\tyow", 'execute "normal yow"' ],
     \ [ "&Cursorline\tyoc", 'execute "normal yoc"' ],
     \ [ "C&ursorcolumn\tyou", 'execute "normal you"' ],
     \ [ "&Xrosshairs\tyox", 'execute "normal yox"' ],
     \ [ "&Background\tyob", 'execute "normal yob"' ],
     \ [ "&Hlsearch\tyoh", 'execute "normal yoh"' ],
     \ [ "&Ignorecase\tyoi", 'execute "normal yoi"' ],
     \ [ "&Diff\tyod", 'execute "normal yod"' ],
     \ [ "&List\tyol", 'execute "normal yol"' ],
     \ [ "&Number\tyon", 'execute "normal yon"' ],
     \ [ "&Relativenumber\tyor", 'execute "normal yor"' ],
     \ [ "&Spell\tyos", 'execute "normal yos"' ],
     \ [ "&Virtualedit\tyov", 'execute "normal yov"' ],
     \ [ "Rul&er\tyoe", 'set invruler' ],
     \ [ "All options", 'options' ],
     \ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
     \ ["LS&C bindings", 'help lsc-default-map', ''],
     \ ["&Cheatsheet", 'help index', ''],
     \ ['T&ips', 'help tips', ''],
     \ ['--',''],
     \ ["&Tutorial", 'help tutor', ''],
     \ ['Quick &reference', 'help quickref', ''],
     \ ['&Summary', 'help summary', ''],
     \ ], 10000)

" }}}

"{{{ Colors
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"
set termguicolors

colorscheme new-moon
"}}}

" vim: fdm=marker foldlevel=0
