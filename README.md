# dotfiles
Personal preferences and configuration

## Terminal configuration

My bashrc, inputrc, and screenrc files.

## Vim (Editor configuration)

My vimrc and some helper scripts to generate tag files:
  * markdown2ctags from https://github.com/jszakmeister/markdown2ctags
  * rst2ctags.py from https://github.com/jszakmeister/rst2ctags.git

## Utilities

Some standard tools:
  * toprc

# Vim cheat-sheet

This is a list of key bindings that I find useful, but keep forgetting. (this list assumes you are using all of the configuration above)

Normal mode:
* Open the tagbar window '<Leader>t'
* Open the undotree window '<Leader>u'
* Open the buffer explorer window '<Leader>b' (jlanzarotta/bufexplorer)
* Open the file browser widnow '<Leader>f' (netrw)
* Open the register window (clipboard) '"' (for insert mode '<C-r>', junegunn/vim-peekaboo)
* Open the mark window ''' (Yilin-Yang/vim-markbar)
* Open the git window '<Leader>g' (jreybert/vimagit)
* Go the next linter issue '<Leader>n'; for previous use '<Leader>p' (w0rp/ale)
* Delete inside brackets 'di' and then the bracket '}' and similar actions (welle/targets.vim)
* Delete all with current indentation 'dii' and similar actions (michaeljsmith/vim-indent-object)
* Change surrounding qoutes from single to double 'cs'"' (tpope/vim-surround)
* Hightlight cursor line '<C-l>'
* Toggle spelling correction '<Leader>s'
* Toggle line wrap '<Leader>w'
* Toggle case sensitive search '<Leader>c'
* Increase / decrease numbers with <C-c> and <C-x>
* Continue editing where you last left INSERT mode 'gi', with the location marked '^'

Insert Mode:
* Increase / decrease indentation of current line with '<C-t> and '<C-d>'
* Open the register window (clipboard) '<C-r>' (for normal mode '"', junegunn/vim-peekaboo)
* Exit insert mode for a single normal mode command '<C-o>'
* XML template expansion '<Leader>,' (mattn/emmet-vim)
* Exit insert mode '<Esc>', '<C-[>'

Ex mode(':'):
* show key name: <C-k> <key>
* show where a variable was last set: verbose set <variable>

Completing use a chained set of completors (lifepillar/vim-mucomplete):
* next / previous entry <C-n>, <C-p>, and <Tab>, <S-Tab>
* next / previous source <C-h>, <C-j>
* Cancel <C-e>, Accept <C-y>
* Some vim built-in completers: dictionary (K), thesaurus (T), keyword (I), tags (]), files (F)

Netrw file browser:
* 'gn' set directory as the tree root
* 'gh' show or hide dotfiles
* 'v' / 'o' open file in split buffer

Git:
  :Gvdiffsplit! HEAD~2
