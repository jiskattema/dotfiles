# dotfiles
Personal preferences and configuration

Easily installed using [GNU stow](https://www.gnu.org/software/stow/).
To install the config files from the ```less``` directory to you home dir use:
```bash
stow -t ~ less
```

## OS
[Fedora](https://fedoraproject.org/) linux with a [Gnome](https://www.gnome.org/) desktop ;)

## Terminal configuration

My alacritty (terminal emulator), tmux (multiplexer), elvish (shell) configurations.
Also (now unused), my bashrc, readline (inputrc), and screenrc files.

# Terminal / ncursus based tools

## actually in use

| Program | Description |
|---------|-------------|
| [alacritty](https://alacritty.org/)            |  terminal emulator |
| [tmux](https://github.com/tmux/tmux/wiki)      |  terminal multiplexer |
| [elvish](https://elv.sh/)                      |  bash alternative (shell) |
| [vim](https://www.vim.org/)                    |  editor |
| [vifm](https://vifm.info/)                     |  file manager |
| [cmus](https://cmus.github.io/)                |  music |
| [ncdu](https://dev.yorhel.nl/ncdu)             |  disc usage analyzer |
| [eza](https://github.com/eza-community/eza)    |  ls alternative |
| less                                           |  pager |
| [btm](https://github.com/ClementTsang/bottom)  |  system monitor |
| qalc | calculator and unit conversion |

## used somewhat

| Program  | Description |
|----------|-------------|
| [vimiv](https://karlch.github.io/vimiv/) | image viewer |
| [aerc](https://aerc-mail.org/) | email |
| jq       | query (grep) json |
| w3m      | terminal webbrowser |

## could be useful

| Program  | Description |
|----------|-------------|
| calcurse | calendar |
| fzf      | fuzzy file finder |
| googler  | search using Google |
| sc-im    | spread sheet |
| pspg     | pager for tabular data |
| hxselect | query XML / HTML |


# Vim cheat-sheet

This is a list of key bindings that I find useful, but keep forgetting. (this list assumes you are using all of the configuration above)

Normal mode:

* Open menu bar '<Leader><Leader>'
* Open the file browser window '-' (vim-vinegar / netrw)
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

# Pagers, Pipes, and Colors
First of all, make sure your terminal and configuration allow the use of fancy
colors. The ```rainbow.sh``` script should print a colorful line with a rainbow
like color gradient.

When used in pipes, color often is lost.
This because programs detect they connected to a pipe instead of a TTY, and do
not produce any colors.  Depending on the program, you force colorized output:

```
grep --color=always
git grep --color=always
ls --color=always
eza --color=always
jq -C
```

Secondly, colors are lost and the output is garbled.  Assuming the terminal
supports color, this happens because final step in the pipe does not pass on the
escape sequences in raw format.
You can force less to do that using:
```
less -R
```

Less has some other useful features:

* turn on/off line wrapping with ```w```
* only show files matching a regexp with ```&```, and for __not__ the matching
  the regexp start it with ```!```.


# Office productivity setup

For work, I'm using Office365 in Firefox ; Teams works better in chromium.
Excel, Word, and Powerpoint run in a VM.

To use email in a terminal:
* Make an App password for [Office365](https://account.activedirectory.windowsazure.com/AppPasswords.aspx). Make an App password for GMail
* Setup dovecot for a local IMAP server using ```.Maildir``` storage, providing offline email, and easier backup.

## Email

aerc for browsing IMAP servers: GMail, Office365 for Business, and dovecot

You can find the IMAP and SMTP settings on the webmail site:
outlook.office365.com:993 with TLS/SSL
smtp.office365.com:587 with STARTLS

aerc knows the default server settings for GMail.

## Calendar and Contacts

Too much hassle to get it syncing and working correctly.

* Use davmail to connect to the Office365 for Business server.
* Use vdirsync to sync calendars and contacts to a local store.
* calcurse calender viewer
* khadr contact book

## SD Card

GNOME used to be optimistic when copying to SD cards; to see if an operation is
actually finished, use:

```bash
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```

# Resources

Manpages are not always the quickest way to find information; I found the following FAQs
and tutorials to be useful:

- [Bash arrays tips and tricks](https://www.shell-tips.com/bash/arrays/)
- [Basic Markdown syntax](https://www.markdownguide.org/basic-syntax/)
