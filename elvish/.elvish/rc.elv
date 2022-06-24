# Settings

use github.com/muesli/elvish-libs/git

# Editor

## use a smallish part of the screen for completion and history
set edit:max-height = 10

## prompt
set edit:rprompt = {
  var info = ( git:status )
  if (!=s $info[branch-name] '') {
    put $info[branch-name] ' '
  }
}  

## matcher
fn match {|seed|
    var inputs = [(all)]
    var results = []
    for matcher [$edit:match-prefix~] {
    # for matcher [$edit:match-prefix~ $edit:match-substr~ $edit:match-subseq~] {
        set results = [(put $@inputs | $matcher &smart-case $seed)]
        if (or $@results) {
            put $@results
            return
        }
    }
    put $@results
}

set edit:completion:matcher[''] = $match~

# Aliasses
# fn ls {|@a| e:ls --color $@a }
fn ls {|@a| e:exa --icons $@a }

fn from-yaml { yj -yj | from-json }
fn from-toml { yj -tj | from-json }
fn from-hcl { yj -cj | from-json }
fn to-yaml { to-json | yj -jy }
fn to-toml { to-json | yj -jt }
fn to-hcl  { to-json | yj -jc }


# Keybindings

## insert mode : use readline with some modifications
use readline-binding
set edit:insert:binding[Ctrl-l] = $edit:clear~
set edit:insert:binding[Ctrl-/] = $edit:location:start~
set edit:insert:binding[Ctrl-n] = $edit:navigation:start~
set edit:insert:binding['Ctrl-['] = $edit:command:start~

# set edit:insert:binding[Ctrl-n] = {
#   set E:elvish_oldpwd = $pwd
#   set edit:navigation:binding[Enter] = {
#       # # insert full path
#       # $edit:insert-at-dot~ (pwd)
#       # $edit:insert-at-dot~ /
#       # # this doesnt work because insert-selected adds a space
#       $edit:navigation:insert-selected-and-quit~
#       cd $E:elvish_oldpwd
#   }
#   set edit:navigation:binding[Ctrl-k] = {
#       # # insert full path
#       # $edit:insert-at-dot~ (pwd)
#       # $edit:insert-at-dot~ /
#       # # this doesnt work because insert-selected adds a space
#       $edit:navigation:insert-selected~
#       $edit:insert-at-dot~ ' '
#   }
#   set edit:navigation:binding[Ctrl-g] = {
#       $edit:close-mode~
#       cd $E:elvish_oldpwd
#   }
#   $edit:navigation:start~
# }


## command more : vi-like mode for insert
# set edit:command:binding['Enter'] = $edit:return-line~
set edit:command:binding['Enter'] = $edit:smart-enter~
set edit:command:binding[a] = { $edit:move-dot-right~ ; $edit:close-mode~ }
set edit:command:binding[A] = { $edit:move-dot-eol~ ; $edit:close-mode~ }

## completion mode Tab
set edit:completion:binding = ( $edit:binding-table~ [
  &Ctrl-p=$edit:completion:up~
  &Ctrl-n=$edit:completion:down~
  &Ctrl-h=$edit:completion:left~
  &Ctrl-l=$edit:completion:right~
  &Tab=   $edit:completion:down-cycle~
  &S-Tab= $edit:completion:up-cycle~
  &' '=   $edit:completion:accept~
  &Enter= $edit:completion:accept~
])

## navigation mode Ctrl-n
set edit:navigation:binding[Enter]  = $edit:navigation:insert-selected-and-quit~
set edit:navigation:binding[Ctrl-k] = $edit:navigation:insert-selected~
set edit:navigation:binding[Ctrl-h] = $edit:navigation:left~
set edit:navigation:binding[Ctrl-l] = $edit:navigation:right~
set edit:navigation:binding[Alt-h] = $edit:navigation:trigger-shown-hidden~

## history mode Ctrl-r
set edit:history:binding[Ctrl-n] = $edit:history:down~  # dont enter navigation mode from history


# Paths
set E:LD_LIBRARY_PATH = "/home/jiska/.local/lib:"$E:LD_LIBRARY_PATH
set E:MANPATH = "/home/jiska/.local/share/man:"$E:MANPATH
set paths = [ /home/jiska/go/bin /home/jiska/.cargo/bin $@paths ]

# Completion
eval (carapace _carapace elvish | slurp)

# Virtual python environment (python -m venv)
var venv = { |&p=env| 
  # convert argument to absolute path
  var pabs = ( readlink -f $p )

  # remove possible value of PYTHONHOME
  if (has-env PYTHONHOME) {
    unset-env PYTHONHOME
  }

  # prepend to path and set VIRTUAL_ENV
  set paths = [ $pabs/bin $@paths ]
  set-env VIRTUAL_ENV $pabs
}
