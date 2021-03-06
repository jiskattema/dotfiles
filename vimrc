" Setup plugin managment using Vudle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

let mapleader = "\<BS>"

" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Plugin 'ayu-theme/ayu-vim'
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

Plugin 'preservim/nerdcommenter'
Plugin 'elzr/vim-json'
Plugin 'mattn/emmet-vim'
Plugin 'alvan/vim-closetag'

Plugin 'lifepillar/vim-mucomplete'

Plugin 'jiskattema/vim-lineage'

" This overwrites some NERDcommenter keybindings
Plugin 'BlueCatMe/TempKeyword'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Vertical split windows are separated by:
set fillchars+=vert:┃

" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" allow hidden buffers (ie. multiple open files with changes)
set hidden

" sticky shift key
"command-bang Q :q
"command-bang Wq :wq
"command-bang WQ :wq

" syntax highlighting
syntax on

" turn on wild menu
set wildmenu

" always show status line
set laststatus=2

" increase space for messages to make longer message more readable
set cmdheight=3

" keep some lines at the top and bottom when scrolling
set scrolloff=8

" dont autoformat (manual invoke format on selection with gq)
set textwidth=80
set formatoptions+=jqnl

" W to set linewrap
set nowrap
nmap <Leader>w :set wrap!<CR>

" Toggle case sensitive searching
nmap <Leader>c :set ignorecase!<CR>
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

" lightline
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
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
  \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'signify-stats': 'sy#repo#get_stats_decorated'
      \ },
  \ 'component' : {
      \   'charvaluehex': '0x%2B'
      \ },
  \ 'subseparator' : { 'left': '', 'right': '' }
  \ }

" backspace key to toggle highlight off
nnoremap <silent> <BS> :noh<CR>
nmap <Leader>` :RemoveMarkHighlights<CR>

" f to open a file browser:
" gn Prune tree
" gh / mh Toggle hiden dotfiles / by suffix / by type
" v / o open file in split buffer
nmap <Leader>f :Ex<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 80
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_sort_options="i"

" b to open the BufExplorer 
nmap <Leader>b :BufExplorer<CR>
let g:bufExplorerDefaultHelp=1

" g to open git window
nmap <Leader>g :MagitOnly<CR>
" dont do anything with vim-fugitive
" (but the functions will stay available)
let g:fugitive_no_maps=1

" ***********************
"     TAB behaviour
" ***********************

" a tab is 4 spaces
set tabstop=2
set shiftwidth=2

" replace tab by spaces,type Ctrl-V<Tab> for real tabs
set expandtab

" highlight tabs
match CursorLine /[\t]/

" Normal mode
" (shift) tab moves through the buffers
nmap <tab> :bn<cr>
nmap <S-tab> :bp<cr>


" ***********************
"    Highlighting
" ***********************

" show matching brackets
" how many tenths of a second to blink matching brackets for
set showmatch
set mat=5

" Ctl-L rotates through cursor line/column highlight mode
" au WinLeave * set nocursorline nocursorcolumn
function! HighLightToggle()
  if &cursorcolumn
    if &cursorline
      set nocursorcolumn
      set nocursorline
    else
      set cursorline
    endif
  else
    if &cursorline
      set nocursorline
      set cursorcolumn
    else
      set cursorline
    endif 
  endif
  " Force a redraw, to keep original Ctl-l functionality
  :redraw!
endfunction

let g:highlightMarks_useSigns = 1
let g:highlightMarks_colors = ['#505060 guifg=White']

" gnome-terminal escapes meta keys instead of setting the 8th bit
" set <M-l>=\el

" Navigate the jumplist with <M-i> instead of <C-i> with is Tab.
" I've configured my terminal to send <M-i> for when i press <C-i>
noremap i <C-i>

" hide cursor line for inactive windows
" au WinLeave * set nocursorline nocursorcolumn
nmap <C-l> :call HighLightToggle()<CR>

" **********************
"     Spelling
" **********************

" s rotates between english, dutch and english+dutch spell checking
function! SpellToggle()
  if &spell
    if &spelllang == "en,nl"
      " nl+en -> en
      execute "set spelllang=en"
      echo "Spell checking for en."
    elseif &spelllang == "en"
      " en -> nl
      execute "set spelllang=nl"
      echo "Spell checking for nl."
    else
      " nl -> off
      execute "set nospell"
      echo "Spell checking off"
    endif
  else
    " off -> nl+en
    execute "set spell"
    execute "set spelllang=en,nl"
    echo "Spell checking for en,nl."
  endif
endfunction
nmap <Leader>s :call SpellToggle()<CR>

" T opens/closes Tagbar window
nmap <Leader>t :TagbarToggle<CR>

" The window should be on the right
let Tlist_Use_Right_Window = 1
" Custom tag generators

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
"   Backup / Undo / Swap
" **************************
" https://begriffs.com/posts/2019-07-19-history-use-vim.html#backups-and-undo
" mkdir ~/.vim/{swap,undodir,backup}

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup

" but do not persist backup after successful write
set nobackup

" use rename-and-write-new method whenever safe
set backupcopy=auto

" patch required to honor double slash at end
if has("patch-8.1.0251")
  " consolidate the writebackups -- not a big
  " deal either way, since they usually get deleted
  set backupdir^=~/.vim/backup//
end

" persist the undo tree for each file
" set undofile
" set undodir^=~/.vim/undodir//

function PruneViminfo()
  " Dont read/write the jumplist to the .viminfo file
  clearjumps
endfunction
autocmd VimLeavePre * call PruneViminfo()
autocmd VimEnter * call PruneViminfo()

" U opens undo window
nnoremap <Leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>
let g:undotree_WindowLayout = 1

" emmet-vim
" Type abbreviation as 'div>p#foo$*3>a' and type '<C-y>,'.
" let g:user_emmet_leader_key = '<BS>e'

" ALE
let g:ale_sign_column_always = 1
nmap <silent> <Leader>n :ALENextWrap<CR>
nmap <silent> <Leader>p :ALEPreviousWrap<CR>

let g:ale_linters = {
  \   'python': ['flake8', 'mypy', 'pylint', 'pyls'],
  \}
let g:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

" Conceal things when possible
" set conceallevel=3

" MUComplete
set infercase
set completeopt+=menuone,noinsert,noselect,popup
set completepopup=align:menu,border:off

" Shut off completion messages
" set shortmess+=c
" If Vim beeps during completion
set belloff+=ctrlg

let g:mucomplete#enable_auto_at_startup = 1
" let g:mucomplete#completion_delay = 1

let g:mucomplete#chains = {
    \ 'default' : ['omni', 'tags', 'incl', 'path', 'uspl']
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
" autocmd CompleteDone * echo "\r"

" FileType plugins sometimes overwrite the omnifunc, in my case for python3 
" re-set the ale completer after running ftplugins
autocmd User * set omnifunc=ale#completion#OmniFunc

" Turn off autocompletion if it is too slow
nmap <Leader>m :MUcompleteAutoToggle<CR>
nmap <Leader>= :let g:mucomplete#chains = {'default' : ['omni', 'tags', 'incl', 'path', 'uspl', 'thes']}<CR>

" Markbar
map <Leader>' <Plug>ToggleMarkbar
let g:markbar_enable_peekaboo = v:false 
let g:markbar_markbar_width = 50
let g:markbar_marks_to_display = '''``[]<>^. abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 01'

" vim-sneak
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

" set Vim-specific sequences for RGB colors
set termguicolors
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"

colorscheme new-moon

set thesaurus+=/home/jiska/.vim/thesaurus/thesaurus.txt

" Diff mode
function DiffGetOrUndo()
  if &diff
    execute(':diffget')
  else
    execute(':SignifyHunkUndo')
  endif
endfunction

map <Leader>d :SignifyDiff!<CR>
map <Leader>v :SignifyHunkDiff<CR>
map <Leader><CR> :diffput<CR>
map <Leader>\ :call DiffGetOrUndo()<CR>

let g:signify_sign_add               = '▌'
let g:signify_sign_delete            = '▌'
let g:signify_sign_delete_first_line = '▌'
let g:signify_sign_change            = '▌'

"Use the external wl-clipboard tool to integrate with Wayland clipboard
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
"function! SynStack ()
"    for i1 in synstack(line("."), col("."))
"        let i2 = synIDtrans(i1)
"        let n1 = synIDattr(i1, "name")
"        let n2 = synIDattr(i2, "name")
"        echo n1 "->" n2
"    endfor
"endfunction
"map gm :call SynStack()<CR>
