# Settings

use str
use github.com/muesli/elvish-libs/git

var carapace_table = $nil

# Editor

## use a smallish part of the screen for completion and history
set edit:max-height = 10

## prompt
set edit:rprompt = {
  var info = ( git:status )
  if (!=s $info[branch-name] '') {
    put $info[branch-name] ' '
  }
  if (!=s $E:VIRTUAL_ENV '') {
     var env_root = (str:trim-suffix $E:VIRTUAL_ENV '/env')
     if (str:has-prefix $pwd $env_root) {
       put '  '
     } else {
       put '  '
     }
   } 
}

# Aliasses
set edit:command-abbr['ll'] = 'exa --color-scale --icons'

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
set edit:insert:binding['S-Tab'] = {
  if $carapace_table {
    # Use previously setup carapace table
    set edit:completion:arg-completer = carapace_table
  } else {
    # Setup carapace for completion candidates
    eval (carapace _carapace elvish | slurp)
    set carapace_table = $edit:completion:arg-completer
  }
  $edit:completion:start~

  # Remove all carapace bindings
  # This way we fall back on the default filecompleter, no matter what.
  set edit:completion:arg-completer = ( make-map [] )
}

## command more : vi-like mode for insert
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
  &Enter= { $edit:completion:accept~ ; $edit:smart-enter~ }
  &Ctrl-y={ $edit:completion:accept~ ; $edit:completion:start~ }
])

## navigation mode Ctrl-n
set edit:navigation:binding[Ctrl-h] = $edit:navigation:left~
set edit:navigation:binding[Ctrl-l] = $edit:navigation:right~
set edit:navigation:binding[Ctrl-y] = { $edit:navigation:insert-selected~ ; $edit:navigation:down~ }
set edit:navigation:binding[Alt-h] = $edit:navigation:trigger-shown-hidden~

## history mode Ctrl-r
set edit:history:binding[Ctrl-n] = $edit:history:down~  # dont enter navigation mode from history

# Environment

## Go
set E:GOROOT = $E:HOME/Code/go/goroot
set E:GOPATH = $E:HOME/Code/go/gopath
set paths = [ $E:GOROOT/bin $E:GOPATH/bin $@paths ]

## Paths
set E:LD_LIBRARY_PATH = "/home/jiska/.local/lib:"$E:LD_LIBRARY_PATH
set E:MANPATH = "/home/jiska/.local/share/man:"$E:MANPATH
set paths = [ /home/jiska/.cargo/bin $@paths ]

# Completion matching
set edit:completion:matcher[argument] = {|seed| edit:match-prefix $seed &ignore-case=$true }

# Virtual python environment (python -m venv)
fn venv { |&p=env| 
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
