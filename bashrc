# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

umask 022

function last_exit_status {
if [ $? -eq 0 -o "`kill -l $? 2>/dev/null`" = TSTP ]; then
  echo -n '.'
else
  echo -n 'x'
fi
}

function parse_git_branch {
  branch=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${branch#refs/heads/}")"
}

# do not freeze terminal on C-s (btw, unfreezing is via Ctrl-q)
# C-s is a common typo when typing screen's C-a
stty -ixon

# nicer prompt
export PS1="\$(last_exit_status) \$(parse_git_branch) \w \$ "
export PROMPT_DIRTRIM=3

# defaults
export EDITOR=/usr/bin/vim
export PAGER=less

# fix TTY fonts
alias FIXFONT="setfont ter-132n.psf.gz"

# force screen to use colors
alias screen="screen -T xterm-256color"
