" Setup plugin managment using Vudle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'elzr/vim-json'
Plugin 'wellle/targets.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'tpope/vim-surround'
Plugin 'majutsushi/tagbar'
Plugin 'w0rp/ale'
Plugin 'itchyny/lightline.vim'
Plugin 'maximbaz/lightline-ale'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
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

" syntax highlighting
syntax on

" turn on wild menu
set wildmenu

" Always show current positions along the bottom 
set ruler

" W to set linewrap
nmap W :set wrap!<CR>

" status line  / lightline
" set statusline=[%n]\ %F\ [%Y]%m%r%h%w%=[\%03.3b,0x\%02.2B]\ %4l,%-4v\ %4p%%
set laststatus=2
set noshowmode
let g:lightline = {
  \'colorscheme': 'solarized',
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
      \             [ 'gitbranch', 'filename', 'linter_checking', 'linter_errors', 'linter_warnings' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
  \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
  \ 'component' : {
      \   'charvaluehex': '0x%2B'
      \ },
  \ 'subseparator' : { 'left': '', 'right': '' }
  \ }

" Remap return key to toggle highlight off when pressing enter in command mode.
nnoremap <silent> <return> :noh<return>

" c controls case sensitive or insensitive search
nmap c :set ignorecase!<CR>

" F to open a file browser; use NERDTree instead of :Ex<CR>
" nmap F :Ex<CR>
nmap F :NERDTreeToggle<CR>

" B to open the BufExplorer 
nmap B :BufExplorer<CR>
let g:bufExplorerDefaultHelp=1

" ***********************
"     TAB behaviour
" ***********************

" a tab is 4 spaces
set tabstop=2
set shiftwidth=2

" replace tab by spaces,type Ctrl-V<Tab> for real tabs
set expandtab

" match all tabs as error with Visual
match Visual /[\t]/

" Input mode
" tab gives auto completion of keywords form current and included files, or if menu is
" active, the next choice
"
" shift-tab gives:
" [ Tag completion
" I Completion from included files shown
" O Omnicompletion info is shown in preview window
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-X>\<C-I>"
   endif
endfunction
inoremap <tab> <C-R>=CleverTab()<CR>
inoremap <S-tab> <C-X><C-O>

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

" alt-L rotates through cursor line/column highlight mode
au WinLeave * set nocursorline nocursorcolumn
execute "hi clear CursorLine"
execute "hi clear CursorColumn"
execute "hi CursorLine ctermfg=white ctermbg=green"
execute "hi CursorColumn ctermfg=white ctermbg=green"
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
endfunction

" gnome-terminal escapes meta keys instead of setting the 8th bit
" execute "set <M-l>=\el"
nmap <C-l> :call HighLightToggle()<CR>

" **********************
"     Spelling
" **********************

" s rotates between english, dutch and english+dutch spell checking
function! SpellToggle()
      if &spell
        if &spelllang == "en"
          " en -> nl
          execute "set spelllang=nl"
          " echo "Spell checking for nl."
        elseif &spelllang == "nl"
          " nl -> nl+en
          execute "set spelllang=nl,en"
          " echo "Spell checking for nl, en."
        else
          " nl+en -> off
          execute "set nospell"
          " echo "Spell checking off"
        endif
      else
        " off -> en
        execute "set spell"
        execute "set spelllang=en"
        " echo "Spell checking for en."
      endif
endfunction
nmap s :call SpellToggle()<CR>

" T opens/closes Tagbar window
nmap T :TagbarToggle<CR>

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
set undofile
set undodir^=~/.vim/undodir//

" U opens undo window
nnoremap U :UndotreeToggle<CR>:UndotreeFocus<CR>

" emmet-vim
" Type abbreviation as 'div>p#foo$*3>a' and type '<C-y>,'.
" default config

" ALE
let g:ale_sign_column_always = 1
highlight SignColumn ctermbg=white
nmap <silent> <C-k> :ALENextWrap<CR>
nmap <silent> <C-j> :ALEPreviousWrap<CR>

" Conceal things when possible
set conceallevel=3
