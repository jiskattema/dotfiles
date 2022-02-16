"{{{ Settings

" Enable syntax highlighting.
"
set nocompatible               " No Vi support
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
set complete=.,w,b,u,t         " Sources for term and line completions
set completeopt=menu,menuone,noinsert,noselect
set dictionary=/usr/share/dict/words
set expandtab                  " Use spaces instead of tabs
set fillchars+=vert:│,fold:⎯
set foldlevelstart=20
set foldmethod=indent          " Simple and fast
set formatoptions=qjnlro       " Format options
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
set noexrc                     " Disable reading of working directory vimrc files
set hlsearch                   " Don't highlight search results by default
set noshowmatch                " No jumping jumping cursors when matching pairs
set showmode                   " No to showing mode in bottom-left corner
set showcmd                    " Show keypresses in bottom-right
set noswapfile                 " No backup files
set wrapscan                   " Don't wrap searches around
set nonumber                   " No line numbers
set path=.,**/*                " Recursively search subdirectories
set wildignore+=**/env/**      " But dont look in virtualenvs, git repos, or npm directories
set wildignore+=**/.git/**
set wildignore+=**/node_modules/**
set pumheight=20               " Height of complete list
set norelativenumber           " No relative numbers
set noruler                    " No ruler with column, row, percentage
set shiftwidth=2               " Default indentation amount
set shortmess=finxToOcImrw     " So dont use SlstWAqF
set showmatch                  " show matching brackets
set signcolumn=number          " Render signs in the number column
set showbreak=↳\               " Use this to wrap long lines
set smartcase                  " Case-smart searching
set smarttab                   " Tab at the start of line inserts blanks
set showtabline=0              " We dont need a tab line
set spelloptions=camel         " When spell checking, assume word boundaries include 'CamelCasing'.
set splitbelow                 " Split below current window
set splitright                 " Split window to the right
set tabstop=4                  " Tab width
set termguicolors              " Enable 24-bit color support for terminal Vim
set textwidth=80               " Standard width before breaking
"set undofile                  " Maintain undo history
"set undodir^=~/.vim/undo//
set updatetime=1000            " Certain plugins use this for CursorHold event triggering
set viminfo=                   " No backups
set wildcharm=<Tab>            " Defines the trigger for 'wildmenu' in mappings
set wildmenu                   " Nice command completions
set wildmode=longest,list      " Complete the next full match
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

func GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
endfun
command -nargs=? G call GitGrep(<f-args>)

augroup send_to_term
  autocmd!
  autocmd TerminalOpen * if &buftype ==# 'terminal' |
        \   let t:send_to_term = +expand('<abuf>') |
        \ endif
augroup END


function! s:op(type, ...)
  let [sel, rv, rt] = [&selection, @@, getregtype('"')]
  let &selection = "inclusive"

  if a:0 
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
  endif

  call s:send_to_term(@@)

  let &selection = sel
  call setreg('"', rv, rt)
endfunction

function! s:send_to_term(keys)
  let bufnr = get(t:, 'send_to_term', 0)
  if bufnr > 0 && bufexists(bufnr) && getbufvar(bufnr, '&buftype') ==# 'terminal'
    let keys = substitute(a:keys, '\n$', '', '')
    call term_sendkeys(bufnr, keys . "\<cr>")
    echo "Sent " . len(keys) . " chars -> " . bufname(bufnr)
  else
    echom "Error: No terminal"
  endif
endfunction

command! -range -bar SendToTerm call s:send_to_term(join(getline(<line1>, <line2>), "\n"))
nmap <script> <Plug>(send-to-term-line) :<c-u>SendToTerm<cr>
nmap <script> <Plug>(send-to-term) :<c-u>set opfunc=<SID>op<cr>g@
xmap <script> <Plug>(send-to-term) :<c-u>call <SID>op(visualmode(), 1)<cr>

nmap yrr <Plug>(send-to-term-line)
nmap yr <Plug>(send-to-term)
xmap R <Plug>(send-to-term)

" }}}

"{{{ Mappings
nmap <Leader>a :ALEToggle<CR>
nmap <Leader>g :MagitOnly<CR>
nmap <Leader>t :Agit<CR>
nmap <Leader>d :SignifyDiff!<CR>
nmap <Leader>h :SignifyHunkDiff<CR>
nmap <Leader>s :SignifyToggle<CR>
nmap <Leader>b :TagbarToggle<CR>

nmap <C-bslash><C-bslash> :ls<CR>
nmap <silent> \| :call quickui#tools#list_buffer('e')<CR>

nmap <silent><Leader>z :call InsertZimHeader()<CR>
nmap yoe :set invruler<CR>
nmap yof :if &fo =~ 'a' \| set fo-=at \| else \| set fo+=at \| endif<CR>
nmap <silent> <S-CR> za

vmap <Enter> <Plug>(EasyAlign)

nnoremap Q :q<CR>

" hit leader twice to open menu
noremap <Leader><Leader> :call quickui#menu#open()<cr>

" Navigate the jumplist with <M-i> instead of <C-i> with is Tab.
" I've configured my terminal to send <M-i> for when i press <C-i>
noremap i <C-i>

" Use <C-K> to delete to the end of the line, unless we're at the end
" then use it to enter a digraph
inoremap <expr> <C-K> col('.')>strlen(getline('.'))?"\<Lt>C-K>":"\<Lt>C-O>d$"
" }}}

"{{{ Plugins

" Vundle is changing the runtime paths. vim will need to re-scan and cache
" everything after vundle is finished.
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
  Plugin 'BlueCatMe/TempKeyword'
  Plugin 'andymass/vim-matchup'
  Plugin 'brtastic/vim-vorg'
  Plugin 'cohama/agit.vim'
  Plugin 'dense-analysis/ale'
  Plugin 'jeetsukumaran/vim-indentwise'
  Plugin 'jiskattema/new-moon.vim'
  Plugin 'joanrivera/vim-zimwiki-syntax'
  Plugin 'jreybert/vimagit'
  Plugin 'junegunn/limelight.vim'
  Plugin 'junegunn/vim-easy-align'
  Plugin 'preservim/tagbar'
  Plugin 'kana/vim-fakeclip'
  Plugin 'mhinz/vim-signify'
  Plugin 'michaeljsmith/vim-indent-object'
  Plugin 'natebosch/vim-lsc'
  Plugin 'pbrisbin/vim-mkdir'
  Plugin 'skywind3000/vim-quickui'
  Plugin 'tommcdo/vim-ninja-feet'
  Plugin 'tpope/vim-characterize'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-rsi'
  Plugin 'tpope/vim-speeddating'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-vinegar'

  Plugin 'mattn/emmet-vim'
  Plugin 'hrsh7th/vim-vsnip'
  Plugin 'rafamadriz/friendly-snippets'

  Plugin 'sillybun/vim-repl'
call vundle#end()

" Re-enable filetype auto-detection and have vim pickup vundle's changes
filetype plugin indent on

" Load packages
packadd! cfilter


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

" vim-indentwise
let g:indentwise_equal_indent_skips_contiguous = 0

" emmet
let g:user_emmet_leader_key = '<C-\>,'

" vsnip
let g:vsnip_snippet_dir = '~/.vim/bundle/friendly-snippets/snippets'
let g:vsnip_snippet_dirs = ['~/.vim/bundle/friendly-snippets/snippets/python']

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

"" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
"" See https://github.com/hrsh7th/vim-vsnip/pull/50
"nmap        s   <Plug>(vsnip-select-text)
"xmap        s   <Plug>(vsnip-select-text)
"nmap        S   <Plug>(vsnip-cut-text)
"xmap        S   <Plug>(vsnip-cut-text)

inoremap <silent> <C-x><C-x> <C-r>=<SID>complete_snippets()<cr>
function! s:complete_snippets() abort
  let word_to_complete = matchstr(strpart(getline('.'), 0, col('.') - 1), '\S\+$')
  let candidates = vsnip#get_complete_items(bufnr('%'))
  let candidates = filter(candidates, 'stridx(v:val.word, word_to_complete)>=0')
  let from_where = col('.') - len(word_to_complete)
  if !empty(candidates)
    call complete(from_where, candidates)
  endif
  return ''
endfunction 

"" vim-repl
let g:sendtorepl_invoke_key = "<F9>"
autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>
autocmd Filetype python nnoremap <F12> <Esc>:REPLToggle<Cr>
"autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>

" vim readline in inputmode
"let g:rsi_no_meta = 1
" }}}

"{{{ Autocommands
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
     \ [ "Ma&git\t\\g", 'execute "normal \\g"', 'Open Magit window (commit)' ],
     \ [ "Agi&t\t\\t", 'execute "normal \\t"', 'Open Agit window (log)' ],
     \ ['--','', '' ],
     \ [ "&Clear keywords\t\\ca", 'call clearmatches()', 'Set keywords using \\#' ],
     \ ['--', '', ''],
     \ ['Text stat&istics', 'call StylePrg()', 'runs GNU style on the current buffer' ],
     \ ['Li&melight', 'Limelight!!', 'Toggle limelight' ],
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
     \ [ "\Auto format\tyof", "if &fo =~ 't' | set fo-=t | else | set fo+=t | endif"],
     \ [ "All options", 'options' ],
     \ ])

" register HELP menu with weight 10000
call quickui#menu#install('&REPL', [
     \ ["&Toggle REPL\tF12", 'REPLToggle'],
     \ ["&Send to REPL\tF9", 'normal [20~'],
     \ ['--', '', ''],
     \ ["Start debugger and run till &cursor", 'REPLDebugStopAtCurrentLine' ],
     \ ["Debug step &line\tF10", 'REPLPDBN'],
     \ ["Debug step &function\tF11", 'REPLPDBS'],
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
