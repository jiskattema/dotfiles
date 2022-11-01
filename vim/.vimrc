"{{{ Settings

let mapleader = "\\"
set nocompatible               " No Vi support
filetype plugin indent on
syntax on

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
set breakindentopt=shift:2,min:5,sbr
"set clipboard=unnamed,unnamedplus
set colorcolumn=81,82          " Highlight 81 and 82 columns                                                          
set conceallevel=0             " Always show text normally
set complete=.,w,b,u,t         " Sources for term and line completions
set completeopt=menu,menuone,noinsert,noselect
set dictionary=/usr/share/dict/words
set expandtab                  " Use spaces instead of tabs
set fillchars+=vert:│
set foldlevelstart=20
set foldmethod=indent          " Simple and fast
set formatoptions=qjnlro       " Format options
set history=200                " Keep 200 changes of undo history
set infercase                  " Smart casing when completing
set ignorecase                 " Search in case-insensitively
set noincsearch                " Dont go to search results immediately
set laststatus=0               " Dont need a statusline
set cmdheight=2                " More room for the status line
set matchtime=5                " blink matching brackets for 5 tenths of a second
set matchpairs=(:),{:},[:]
set mouse=""                   " No mouse support in the terminal
set mousehide                  " Hide mouse when typing text
set nobackup                   " No backup files
set noexrc                     " Disable reading of working directory vimrc files
set hlsearch                   " Highlight search results by default
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
set shortmess=finxToOcImrwsS   " So dont use SlstWAqF
set showmatch                  " show matching brackets
set signcolumn=number          " Render signs in the number column
set showbreak=∙
set smartcase                  " Case-smart searching
set smarttab                   " Tab at the start of line inserts blanks
set showtabline=0              " We dont need a tab line
set spelloptions=camel         " When spell checking, assume word boundaries include 'CamelCasing'.
set splitbelow                 " Split below current window
set splitright                 " Split window to the right
set tabstop=4                  " Tab width
set termguicolors              " Enable 24-bit color support for terminal Vim
set textwidth=80               " Standard width before breaking
set undofile                   " Maintain undo history
set undodir^=~/.vim/undo//
set updatetime=1000            " Certain plugins use this for CursorHold event triggering
set viminfo=%,'50,/50,:50
set viminfofile=.git/viminfo
set wildcharm=<Tab>            " Defines the trigger for 'wildmenu' in mappings
set wildmenu                   " Nice command completions
set wildmode=longest:full
set wildoptions=tagfile
set nowrap                     " Do not wrap long lines
set cryptmethod=blowfish2
set listchars=eol:$,tab:>-,trail:-
set nocursorline
set cursorlineopt=both         " line number and buffer line
set keywordprg=:DictPrg

" bug fix where elvish shell needs a space around the redirect, and bash accepts
" both. Fixes netrw-gx command
set shellredir=\ \>\ 
set shell=/usr/bin/sh          " Use something POSIX compattible
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

function NetrwNewNamedFile()
  call inputsave()
  call feedkeys(strftime("%Y%m%d.txtODODODOD"))
  let fname = input('Enter vorg filename: ')
  call inputrestore()
  execute "NetrwKeepj e ".fnameescape(b:netrw_curdir."/".fname)
endfunction

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
" }}}

"{{{ Mappings
nmap <Leader>a :ALEToggle<CR>
nmap <Leader>g :MagitOnly<CR>
nmap <Leader>t :Agit<CR>
nmap <Leader>d :SignifyDiff!<CR>
nmap <Leader>h :SignifyHunkDiff<CR>
nmap <Leader>s :SignifyToggle<CR>
nmap <Leader>b :TagbarToggle<CR>
nmap <Leader>= :ALEFix <Tab><C-n>

nmap <silent>  :ls<CR>
nmap <silent> \| :ls<CR>
nmap <silent> <C-_> :call quickui#tools#list_buffer('e')<CR>

nmap yoe :set invruler<CR>
nmap yof :if &fo =~ 'a' \| set fo-=at \| else \| set fo+=at \| endif<CR>
nmap <silent> <S-CR> za

vmap <Enter> <Plug>(EasyAlign)

nnoremap Q :q<CR>

nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" hit leader twice to open menu
noremap <Leader><Leader> :call quickui#menu#open()<cr>

" Navigate the jumplist with <M-i> instead of <C-i> with is Tab.
" I've configured my terminal to send <M-i> for when i press <C-i>
noremap i <C-i>

" Open a terminal with C-z (elvish terminal doesnt do backgrounding anyways)
noremap  :execute "terminal ++close " . $GOPATH . "/bin/elvish"<CR>

" Use <C-K> to delete to the end of the line, unless we're at the end
" then use it to enter a digraph
inoremap <expr> <C-K> col('.')>strlen(getline('.'))?"\<Lt>C-K>":"\<Lt>C-O>d$"

" Close the preview window from insert mode
inoremap <C-g><C-g> <Esc>:pclose<CR>gi

" :terminal bindings
command! -range -bar SendToTerm call s:send_to_term(join(getline(<line1>, <line2>), "\n"))
nmap <script> <Plug>(send-to-term-line) :<c-u>SendToTerm<cr>
nmap <script> <Plug>(send-to-term) :<c-u>set opfunc=<SID>op<cr>g@
xmap <script> <Plug>(send-to-term) :<c-u>call <SID>op(visualmode(), 1)<cr>

nmap yrr <Plug>(send-to-term-line)
nmap yr <Plug>(send-to-term)
xmap R <Plug>(send-to-term)

" vsnip: Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" vsnip: Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

inoremap <silent> <C-x><C-x> <C-r>=<SID>complete_snippets()<cr>

" vorg
nmap <F12> :set ft=vorg<CR>

" matchup
nmap <Leader>? :MatchupWhereAmI?<CR>

" vim-highlighter
nmap [h :Hi {<CR>
nmap ]h :Hi }<CR>
nmap [H :Hi <<CR>
nmap ]H :Hi ><CR>

" ex-showmarks
let g:showmarks_enable = 0
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"

let g:showmarks_textlower="unicode"
let g:showmarks_textupper="unicode"

" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1 
" }}}

"{{{ Configure plugins

" Load packages
packadd! cfilter

" Markdown
let g:markdown_folding = 1

" NetRW
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_preview = 1
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_list_hide.=netrw_gitignore#Hide()

" Signify
let g:signify_disable_by_default = 0

" ALE
let g:ale_disable_lsp = 1
let g:ale_set_signs = 0

" vim-lsc
let g:lsc_auto_map = {'defaults': v:true, 'NextReference': '', 'PreviousReference': ''}
let g:lsc_reference_highlights = v:false
let g:lsc_server_commands = {
  \ 'python': 'pylsp',
  \ 'go': $GOPATH . '/bin/gopls',
  \ 'elvish': $GOPATH . '/bin/elvish -lsp',
  \ }

" vim-indentwise
let g:indentwise_equal_indent_skips_contiguous = 0

" emmet
let g:user_emmet_leader_key = '<C-\>,'

" vsnip
let g:vsnip_snippet_dir = '~/.vim/bundle/friendly-snippets/snippets'
let g:vsnip_snippet_dirs = ['~/.vim/bundle/friendly-snippets/snippets/python']

" vim readline in inputmode
" Disable META mappings because they break i_<Esc> timeouts for me
let g:rsi_no_meta = 1

let g:gutentags_define_advanced_commands = 1

let g:tagbar_type_vorg = {
\ 'sort' : 0, 
\ 'sro' : '""',
\ 'kind2scope' : {
\   'c' : 'chapter',
\   's' : 'section',
\   'S' : 'subsection',
\   't' : 'subsubsection',
\   'T' : 'l3subsection',
\   'u' : 'l4subsection',
\   'f' : 'tag',
\   'D' : 'document tag',
\ },
\ 'scope2kind' : {
\   'chapter'       : 'c',
\   'section'       : 's',
\   'subsection'    : 'S',
\   'subsubsection' : 't',
\   'l3subsection'  : 'T',
\   'l4subsection'  : 'u',
\   'tag'           : 'f',
\   'document tag'  : 'D',
\ },
\ 'kinds' : [
\   'D:document',
\   'c:chapter:0:1',
\   's:section:0:1',
\   'S:subsection:0:1',
\   't:subsubsection:0:1',
\   'T:l3subsection:0:1',
\   'u:l4subsection:0:1',
\   'f:tag',
\ ]
\ }
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

augroup netrw_mapping
  autocmd!
  autocmd FileType netrw nnoremap <buffer> & :call NetrwNewNamedFile()<CR>
augroup END

augroup send_to_term
  autocmd!
  autocmd TerminalOpen * if &buftype ==# 'terminal' |
        \   let t:send_to_term = +expand('<abuf>') |
        \ endif
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
   \ ['Text stat&istics', 'call StylePrg()', 'runs GNU style on the current buffer' ],
   \ ['&Limelight', 'Limelight!!', 'Toggle limelight' ],
   \ ['&Unicoder', 'Unicoder', 'Use abbreviations to insert unicode characters'],
   \ ['Show &Marks', 'ShowMarksToggle', 'Highlight marks'],
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

" Make modified arrow keys (<C-Left> etc.) work in alacritty 
execute "set <xUp>=\<Esc>[@;*A"
execute "set <xDown>=\<Esc>[@;*B"
execute "set <xRight>=\<Esc>[@;*C"
execute "set <xLeft>=\<Esc>[@;*D"

" vim: fdm=marker foldlevel=0 fileencoding=utf-8
