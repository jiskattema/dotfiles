" Setup plugin managment using Vudle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

"let mapleader = "\<BS>"
let mapleader = "\\"

" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
"let g:ale_completion_enabled = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'jiskattema/new-moon.vim'

Plugin 'powerman/vim-plugin-AnsiEsc'

" Add as line 93:
" exe ":sign define ". name ." text=". a:mark
Plugin 'tumbler/highlightmarks'

Plugin 'maximbaz/lightline-ale'
Plugin 'w0rp/ale'
Plugin 'itchyny/lightline.vim'

Plugin 'jlanzarotta/bufexplorer'
Plugin 'mbbill/undotree'
Plugin 'majutsushi/tagbar'

Plugin 'junegunn/vim-peekaboo'
Plugin 'Yilin-Yang/vim-markbar'

Plugin 'wellle/targets.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'tpope/vim-surround'
Plugin 'justinmk/vim-sneak'

Plugin 'tpope/vim-fugitive'
Plugin 'jreybert/vimagit'
Plugin 'mhinz/vim-signify'

Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-characterize'
Plugin 'tpope/vim-speeddating'

Plugin 'preservim/nerdcommenter'
Plugin 'elzr/vim-json'
Plugin 'mattn/emmet-vim'
Plugin 'alvan/vim-closetag'

Plugin 'hrsh7th/vim-vsnip'
Plugin 'hrsh7th/vim-vsnip-integ'
Plugin 'craigmac/vim-vsnip-snippets'

Plugin 'lifepillar/vim-mucomplete'

" This overwrites some NERDcommenter keybindings
Plugin 'BlueCatMe/TempKeyword'

Plugin 'joanrivera/vim-zimwiki-syntax'

Plugin 'kana/vim-fakeclip'

Plugin 'gillyb/stable-windows'

Plugin 'skywind3000/vim-quickui'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Vertical split windows are separated by:
set fillchars+=vert:┃

" allow hidden buffers (ie. multiple open files with changes)
set hidden

" syntax highlighting
syntax on

" turn on wild menu
set wildmenu

" always show status line
set laststatus=2

" increase space for messages to make longer message more readable
set cmdheight=3

" keep some lines at the top and bottom when scrolling
"set scrolloff=8

" dont autoformat (manual invoke format on selection with gq)
set textwidth=80
set formatoptions+=jqnlro
set formatoptions-=tc

" conceal things: (0) never (3) whenever possible
set conceallevel=0

" dont wrap lines (wrap [ow ]ow yow) 
set nowrap

" Toggle case sensitive searching ([oi ]oi yoi)
set ignorecase
set smartcase

" I dont like Ex mode..
nnoremap Q <nop>

" Use C-x / C-c to increase / decrease numbers
nmap <C-c> <C-a>

" Dont jump ahead when searching
set noincsearch
       
" default to English and Dutch
set spelllang=en,nl

" a tab is 2 spaces
set tabstop=2
set shiftwidth=2

" replace tab by spaces,type Ctrl-V<Tab> for real tabs
set expandtab

" gnome-terminal escapes meta keys instead of setting the 8th bit
" set <M-l>=\el

" Navigate the jumplist with <M-i> instead of <C-i> with is Tab.
" I've configured my terminal to send <M-i> for when i press <C-i>
noremap i <C-i>

" ***********************
"    Highlighting and colors
" ***********************

" highlight tabs
match CursorLine /[\t]/

" backspace key to toggle (search) highlight off
"nnoremap <silent> <BS><BS> :noh<CR>

" show matching brackets
set showmatch

" how many tenths of a second to blink matching brackets for
set mat=5

" highlight marks
nmap <Leader>` :RemoveMarkHighlights<CR>
let g:highlightMarks_useSigns = 1
let g:highlightMarks_colors = ['#505060 guifg=White']

" hide cursor line for inactive windows
" au WinLeave * set nocursorline nocursorcolumn

" set Vim-specific sequences for RGB colors
set termguicolors
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"

colorscheme new-moon

set thesaurus+=/home/jiska/.vim/thesaurus/thesaurus.txt

" ***************************
"       Lightline
" ***************************
set noshowmode
let g:lightline = {
  \'colorscheme': 'one',
  \'component_expand' : {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \ },
  \'component_type' : {
      \   'linter_checking': 'left',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \ },
  \'active' : {
      \   'left': [ [ 'mode', 'paste', 'spell', 'modified', 'readonly' ],
      \             [ 'gitbranch', 'filename', 'linter_checking', 'linter_errors', 'linter_warnings', 'signify-stats' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
  \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'signify-stats': 'sy#repo#get_stats_decorated'
      \ },
  \ 'subseparator' : { 'left': '', 'right': '' }
  \ }


" ****************************************
"       File browser
" gn Prune tree
" gh / mh Toggle hiden dotfiles / by suffix / by type
" v / o open file in split buffer
" p preview file (do not leave netrw)
" ****************************************
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_browsex_viewer = 'xdg-open'
let g:netrw_preview = 1


" ****************************************
"       Buffer explorer
" <Leader>b to open
" ****************************************
nmap <Leader>b :BufExplorer<CR>
let g:bufExplorerDefaultHelp=1
let g:bufExplorerDisableDefaultKeyMapping=1


" ****************************************
"       version control / Magit + fugitive
" <Leader>g to open
" ****************************************
nmap <Leader>g :MagitOnly<CR>

" dont do anything with vim-fugitive
" (but the functions will stay available)
let g:fugitive_no_maps=1


" *****************************
"     Spelling
" 
" on/off/toggle:   [os ]os yos
" next/prev:       [s  ]s
" *****************************
set spelllang=en,nl

" T opens/closes Tagbar window
nmap <Leader>t :TagbarToggle<CR>

" The window should be on the right
let Tlist_Use_Right_Window = 1


" **********************
" Custom tag generators
" **********************

" https://github.com/jszakmeister/markdown2ctags
" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/scripts/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" https://github.com/jszakmeister/rst2ctags
" Add support for reStructuredText files in tagbar.
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '~/.vim/scripts/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" **************************
"       Backup / Undo / Swap
" https://begriffs.com/posts/2019-07-19-history-use-vim.html#backups-and-undo
" mkdir ~/.vim/{swap,undodir,backup}
" **************************

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
" set swapfile
" set directory^=~/.vim/swap//

" protect against crash-during-write
" set writebackup

" but do not persist backup after successful write
" set nobackup

" use rename-and-write-new method whenever safe
" set backupcopy=auto

" patch required to honor double slash at end
" if has("patch-8.1.0251")
"   " consolidate the writebackups -- not a big
"   " deal either way, since they usually get deleted
"   set backupdir^=~/.vim/backup//
" end

" persist the undo tree for each file
" set undofile
" set undodir^=~/.vim/undodir//

function PruneViminfo()
  " Dont read/write the jumplist to the .viminfo file
  clearjumps
endfunction
autocmd VimLeavePre * call PruneViminfo()
autocmd VimEnter * call PruneViminfo()

" ***********************
"       Undo window
" <Leader>u to open
" ***********************
nnoremap <Leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>
let g:undotree_WindowLayout = 1

" emmet-vim
" Type abbreviation as 'div>p#foo$*3>a' and type '<C-y>,'.
" let g:user_emmet_leader_key = '<BS>e'

" ***********************
"       ALE - linter and completion source
" ***********************
let g:ale_sign_column_always = 1

" pyls
let g:ale_linters = {
  \   'python': ['flake8', 'mypy', 'pylint', 'pyls'],
  \}
let g:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

" FileType plugins sometimes overwrite the omnifunc, in my case for python3 
" re-set the ale completer after running ftplugins
" autocmd User * set omnifunc=ale#completion#OmniFunc

" ***********************
"       vsnip / snippets 
" ***********************
let g:vsnip_snippet_dir="~/.vim/bundle/vim-vsnip-snippets/snippets/"

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'


" ***********************
"       MUComplete
" ***********************
set infercase
set complete=
set completeopt+=menuone,noinsert,noselect,popup
set completepopup=align:menu,border:off

" Shut off completion messages
set shortmess+=cmnrxT
set shortmess-=S

" If Vim beeps during completion
set belloff+=ctrlg

let g:mucomplete#enable_auto_at_startup = 1
" let g:mucomplete#completion_delay = 1

"let g:mucomplete#can_complete = {}
"let g:mucomplete#can_complete.default = {
"    \  'omni': {
"    \     t -> g:mucomplete_with_key
"    \   }
"    \ }
let g:mucomplete#chains = {
    \ 'default' : ['tags', 'incl', 'path', 'uspl', 'vsnip', 'omni']
    \ }


" pressing right (left) after a completion completes with the next occurring word
imap <expr> <right> mucomplete#extend_fwd("\<right>")
imap <expr> <left> mucomplete#extend_bwd("\<left>")

fun! ColorfulMessages()
  echohl Label
  unsilent echo "Completing from  "
  echohl Special
  unsilent echon get(g:mucomplete#msg#methods, get(g:, 'mucomplete_current_method', ''))
  echohl None
  " Force updating the cursor
  let &ro=&ro
endfun
autocmd User MUcompletePmenu call ColorfulMessages()

" Clear the command line when the menu is dismissed
autocmd CompleteDone * echo "\r"

" Turn on/off/toggle autocompletion
nmap [om :MUcompleteAutoOn<CR>
nmap ]om :MUcompleteAutoOff<CR>
nmap yom :MUcompleteAutoToggle<CR>

" Turn on/off/toggle linting
nmap [oa let b:ale_enabled = 1<CR>
nmap ]oa let b:ale_enabled = 0<CR>
nmap yoa let b:ale_enabled = ! b:ale_enabled<CR>

" Reset to default completion chains
nmap <Leader>= :let g:mucomplete#chains = {
      \ 'default' : ['tags', 'incl', 'path', 'uspl', 'thes', 'vsnip', 'omni']
      \ }<CR>

" ***********************
"       Markbar
" <Leader>m to open
" ***********************
map <Leader>m <Plug>ToggleMarkbar
let g:markbar_enable_peekaboo = v:false 
let g:markbar_markbar_width = 50
let g:markbar_marks_to_display = '''``[]<>^. abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 01'


" ***********************
"       vim-sneak
" ***********************
let g:sneak#map_netrw = 0
let g:sneak#label = 1
let g:sneak#prompt = 'sneak > '

" 1-character enhanced 'f'
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F

" visual-mode
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F

" operator-pending-mode
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" 1-character enhanced 't'
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

" visual-mode
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T

" operator-pending-mode
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T


" ********************
"       Signify - diff mode
" ********************
map <Leader>d :SignifyDiff!<CR>
map <Leader>h :SignifyHunkDiff<CR>

let g:signify_sign_add               = '▌'
let g:signify_sign_delete            = '▌'
let g:signify_sign_delete_first_line = '▌'
let g:signify_sign_change            = '▌'


" ***************************
"       Clipboard
" ***************************
let g:fakeclip_provide_clipboard_key_mappings = 1
let g:fakeclip_terminal_multiplexer_type = "gnuscreen"


" ***************************
"       Debug
" ***************************
"function! SynStack ()
"    for i1 in synstack(line("."), col("."))
"        let i2 = synIDtrans(i1)
"        let n1 = synIDattr(i1, "name")
"        let n2 = synIDattr(i2, "name")
"        echo n1 "->" n2
"    endfor
"endfunction
"map gm :call SynStack()<CR>


" ***************************
"       Grep
" By default, do 'git grep'
" https://vi.stackexchange.com/questions/21566/dont-capture-stderr-for-git-grep-as-grepprg
" ***************************
let &grepprg="git --no-pager grep --no-color -n $*"                                                                                  
let &grepformat="%f:%l:%m,%m %f match%ts"  

" Grep integration: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
" use ag for search (a faster grep, from the the_silver_searcher package on fedora)
function! Grep(...)
  return system('ag --vimgrep ' . join(a:000, ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END


" ***************************
"       Zim desktop wiki
" Function to insert a header in the Zim wiki style
" Key mapping to insert a Zim Wiki header 
" taken from vim script https://www.vim.org/scripts/script.php?script_id=3703
" ***************************
function! InsertZimHeader()
   let curr_date=strftime('%F', localtime())
   let curr_time=strftime('%T', localtime())
   let title=strftime('%A, %d. %B %Y', localtime())
   exec "normal! ggiContent-Type: text/x-zim-wiki\<CR>Wiki-Format: zim 0.4\<CR>Creation-Date: ".curr_date."T".curr_time."\<CR>\<CR>==== ".title." ====\<CR>" 
   set filetype=zimwiki
endfunction
map <silent><Leader>z :call InsertZimHeader()<CR>

" clear all the menus
nmap <Leader>f :call quickui#tools#list_function()<CR>
call quickui#menu#reset()
let g:quickui_border_style = 2
"let g:quickui_color_scheme = 'papercol_light'
"let g:quickui_color_scheme = 'gruvbox'

" use [text, command] to represent an item.

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Plugins', [
     \ [ "&Buffers\t\\b", 'execute "normal \\b"' ],
     \ [ "&Tags\t\\t", 'execute "normal \\t"' ],
     \ [ "&Undo\t\\u", 'execute "normal \\u"' ],
     \ [ "&Functions\t\\f", 'call quickui#tools#list_function()' ],
     \ [ "Fil&es\t-", 'Ex' ],
     \ [ "&Diff file\t\\d", 'SignifyDiff' ],
     \ [ "Diff &hunk\t\\h", 'SignifyHunkDiff' ],
     \ [ "&Git\t\\g", 'execute "normal \\g"' ],
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
     \ [ "&Ale\tyoa", 'let g:ale_enabled = ! g:ale_enabled' ],
     \ [ "&Mucomplete\tyom", 'execute "normal yom"' ],
     \ [ "All options", 'options' ],
     \ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
     \ ["&Cheatsheet", 'help index', ''],
     \ ['T&ips', 'help tips', ''],
     \ ['All &mappings', 'call ShowMappings()' ],
     \ ['--',''],
     \ ["&Tutorial", 'help tutor', ''],
     \ ['&Quick Reference', 'help quickref', ''],
     \ ['&Summary', 'help summary', ''],
     \ ], 10000)

"hi! QuickBG ctermfg=0 ctermbg=7 guifg=black guibg=gray
"hi! QuickSel cterm=bold ctermfg=0 ctermbg=2 gui=bold guibg=brown guifg=gray
"hi! QuickKey term=bold ctermfg=9 gui=bold guifg=#f92772
"hi! QuickOff ctermfg=59 guifg=#75715e
"hi! QuickHelp ctermfg=247 guifg=#959173

hi! QuickBG guifg=#080808 guibg=#94C7B5
hi! QuickKey guifg=#ffeead guibg=#94C7B5
hi! QuickSel guifg=#ffeead guibg=#080808
hi! QuickOff guifg=#ffffff

function ShowMappings()
  let all_mappings = split(
        \ substitute(
        \     execute("map"),
        \     '&', '🙴', 'g'),
        \ '\n')
  let show_mappings = filter(all_mappings, 'v:val !~ "^[nosvx ] *<Plug>"')
  call sort(show_mappings)

  call quickui#listbox#open(show_mappings, {})
endfunction

" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>

