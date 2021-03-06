# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

umask 022

function last_exit_status {
if [ $? -eq 0 -o "`kill -l $? 2>/dev/null`" = TSTP ]; then
  echo -n ' '
else
  echo -n 'x'
fi
}

function parse_git_branch {
  branch=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${branch#refs/heads/}")"
}

# do not freeze terminal on <C-s> (btw, unfreezing is via <C-q>)
# <C-s> is a common typo when typing screen's <C-a>
stty -ixon

# nicer prompt
export PS1="\$(last_exit_status) \$(parse_git_branch) \w \$ "
export PROMPT_DIRTRIM=3

# defaults
export EDITOR=/usr/bin/vim
# export PAGER='vim -c ":AnsiEsc" -R -'
export PAGER=less
# make sure less uses color for standout highlighting
# https://unix.stackexchange.com/questions/179173/make-less-highlight-search-patterns-instead-of-italicizing-them
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[39;49m'

# fix TTY fonts
alias FIXFONT="setfont ter-132n.psf.gz"

# force screen to use colors
alias screen="screen -T xterm-256color"

alias venv='. env/bin/activate'
