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

## SD Card
```bash
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```

# Vim cheat-sheet

This is a list of key bindings that I find useful, but keep forgetting. (this list assumes you are using all of the configuration above)

Normal mode:
* Open menu bar '<Leader><Leader>'
* Open the file browser window '-' (vim-vinegar / netrw)
* Open the git window '<Leader>g' (jreybert/vimagit)
* Go to the next/previous location <C-o>, <C-i> (built-in jump list)
* Go to the next/previous change in the file 'g;' and 'g,' (built-in changes list)
* Go to the start/end of the last selection "'<" and "'>"
* Go to the start/end of the last change "'[" and "']"
* Move the cursor to a window 'C-w hjkl', or move the window 'C-w HJKL'
* Delete inside brackets 'di' and then the bracket '}' and similar actions (welle/targets.vim)
* Delete with indentation 'dii' and similar actions (michaeljsmith/vim-indent-object)
* Change surrounding quotes from single to double 'cs'"' (tpope/vim-surround)
* Increase / decrease numbers with <C-a> and <C-x>
* Continue editing where you last left INSERT mode 'gi', with the location marked '^'
* Resize the current window to N lines 'zN<Cr>'
* Add keyword under cursor to a temporary highlight group '<Leader>#', where # is a number


Insert Mode:
* Increase / decrease indentation of current line with '<C-t>' and '<C-d>'
* Exit insert mode for a single normal mode command '<C-o>'
* XML template expansion '<C-y>,' (mattn/emmet-vim) also does snippets and
  lorem-ipsum text generation via 'lorem<C-y>,' or 'lorem100<C-y>,'
* Exit insert mode '<Esc>', '<C-[>'


Visual Mode:
* Select block with the same indentation 'ii'
* Go to the other end of the selection o and O
* Select in all in/around () {} <> [] <tag></tag> ` '' "" with ia followed by bB<['"`t


Diff mode:
* Go to next/previous '[]c' (also when current file is in a git repo)
* Put chunk dp
* Get (obtain) chunk do 


Ex mode(':'):
* show key name: <C-k> <key>
* show where a variable was last set: verbose set <variable>
* search in completion <C-d>


Completing:
* Some vim built-in completers: dictionary (K), thesaurus (T), keyword (I), tags (]), files (F), omni (O)
* next / previous entry <C-n>, <C-p>
* Cancel <C-e>, Accept <C-y>
* Start completion in insert mode <C-n>, <C-p>


Netrw file browser:
* '-' go to directory containing current file
* 'gn' set directory as the tree root
* 'gh' show or hide dotfiles
* 'v' / 'o' open file in split buffer
* '%' edit new file at the displayed location


# Office productivity setup

Make an App password for Office365 https://account.activedirectory.windowsazure.com/AppPasswords.aspx
Make an App password for GMail

Setup dovecot for a local IMAP server, providing offline email, and easier backup.

## Email

aerc for browsing IMAP servers: GMail, Office365 for Business, and dovecot

You can find the IMAP and SMTP settings on the webmail site:
outlook.office365.com:993 with TLS/SSL
smtp.office365.com:587 with STARTLS

aerc knows the default server settings for GMail.


## Calendar and Contacts

Use davmail to connect to the Office365 for Business server.
Use vdirsync to sync calendars and contacts to a local store.

calcurse calender viewer
khadr contact book


# Git


```
git log --graph --pretty=format:'%h - %d %s (%cr) <%an>' | vim -R -c 'set filetype=git nowrap' -
```


# Pagers, Pipes, and Colors

When used in pipes, color often is lost.
This because programs detect they connected to a pipe instead of a TTY, and do
not produce any colors.  Depending on the program, you force colorized output:
```
grep --color=always
git grep --color=always
jq -C
```

Secondly, colors are lost and the output is garbled.  Assuming the terminal
supports color, this happens because final step in the pipe does not pass on the
escape sequences in raw format.
You can force less to do that using:
```
less -R
```

Finally, some pagers add colors themselves.  The color scheme is based on an
argument, because due to the pipe there is no filename, no extentions and hence
no filetype.
```
bat -l md
```


# terminal / ncursus tools

## actually in use

cmus     - music
jq       - query (grep) json
mdn      - markdown pager using pandoc/w3m 
ncdu     - disc usage analyzer
tmux     - terminal multiplexer

## used somewhat

vifm     - file browser
aerc     - email
hxselect - query XML / HTML
sc-im    - spread sheet
w3m      - terminal webbrowser

## could be useful

bat      - cat replacement
btop     - system monitor
calcurse - calendar
feh      - image viewer
fzf      - fuzzy file finder
googler  - search using Google
pspg     - pager for tabular data
toilet   - big text using ascii art


# Resources

[Bash arrays tips and tricks](https://www.shell-tips.com/bash/arrays/)


