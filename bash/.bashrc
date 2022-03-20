# .bashrc

NORMAL="\001\033[00m\002"
   RED="\001\033[0;31m\002"
 GREEN="\001\033[0;32m\002"
  BLUE="\001\033[0;36m\002"
   DOT="\001\033[01;94m\002"
OFFSET="\001\eD\eD\e[A\e[A\e[A\e[A\eD\eD\002"

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source .profile (as .bashrc is ignored for non-interactive sessions)
# https://superuser.com/a/183980
if [ -r ~/.profile ]; then
  . ~/.profile
fi

umask 022

# do not freeze terminal on <C-s> (btw, unfreezing is via <C-q>) <C-s> is a
# common typo when typing screen's <C-a>
stty -ixon

# nerd font https://www.nerdfonts.com/cheat-sheet

# red-colored x on error status
function last_exit_status {
if [ $? -eq 0 -o "`kill -l $? 2>/dev/null`" = TSTP ]; then
  echo -e '  '
else
  echo -e $RED'❎'
fi
}

function parse_git_branch {
  branch=$(git symbolic-ref HEAD 2> /dev/null) || return
  # echo ${branch#refs/heads/}
  echo -e $BLUE'\uf09b'
}

function parse_venv {
if [ -n "${VIRTUAL_ENV}" ]; then
  if [[ $(pwd)/ = ${VIRTUAL_ENV%%env}* ]]; then
  echo -e ${GREEN}" \uf820 "
  else
  echo -e ${RED}" \uf820 "
  fi
fi
}

function i {
  echo
  # working directory
  echo -e ' \uf115  ' `pwd`

  # git information
  branch=$(git symbolic-ref HEAD 2> /dev/null)
  if [ "${branch}" ]; then
  echo -e ' \uf09b  ' ${branch#refs/heads/}
  fi

  if [ "${VIRTUAL_ENV}" ]; then
  echo -e ' \uf820  ' ${VIRTUAL_ENV%%env}
  fi
  echo -e ' \uf5ef  ' `date "+%Y-%m-%d %H:%M (%s)"`

  SLINE=""
  if [ "${STY}" ]; then
  SLINE="${SLINE} \uf879  ${WINDOW}"
  fi
  SLINE="${SLINE} \ufc0c $(jobs | grep 'Running' | wc -l)"
  SLINE="${SLINE} \u23fe $(jobs | grep 'Stopped' | wc -l)"
  SLINE="${SLINE} \uf11c $(history | wc -c)"
  echo -e "${SLINE}"
  echo
  jobs
  echo
}

# nicer prompt
export PS1="\$(last_exit_status) \$(parse_git_branch) \w \$ "
export PROMPT_DIRTRIM=3

# defaults
export EDITOR=/usr/bin/vim

# make sure less uses color for standout highlighting
# https://unix.stackexchange.com/questions/179173/make-less-highlight-search-patterns-instead-of-italicizing-them
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[39;49m'
export PAGER="less -Rgi"
alias less="less -Rgi"

# ask ls to do coloring
alias ls="ls --color=always"

# keep history
shopt -s histappend
HISTCONTROL=erasedups:ignorespace

# vifm is confused about the termcaps
alias vifm="TERM=alacritty vifm"

# fix TTY fonts
alias FIXFONT="setfont ter-132n.psf.gz"

# force screen to use colors
alias screen="screen -T xterm-256color"

# activate a local virtualenv
alias venv='source env/bin/activate'
export VIRTUAL_ENV_DISABLE_PROMPT=1

# pretty print a clock
alias clock='date "+%Y-%m-%d %H:%m" | toilet  -W --filter metal -f smmono9.tlf'

export PATH=/home/jiska/.local/bin:$PATH


select_files() {
  # local files="$(python2 -c 'import Tkinter, tkFileDialog; Tkinter.Tk().withdraw(); print(" ".join(map(lambda x: "'"'"'"+x+"'"'"'", tkFileDialog.askopenfilename(multiple=1))))')"
  mapfile -t files < <(vifm --choose-files - .)
  READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}"${files[@]}"${READLINE_LINE:READLINE_POINT}"
  length="${files[@]}"
  READLINE_POINT=$((READLINE_POINT + ${#length}))
}
bind -x '"\C-g":select_files'
