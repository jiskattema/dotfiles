#!/usr/bin/bash

for i in bashrc inputrc screenrc toprc vimrc vim; do
  read -r -p "Copy %i ? [y/N] " answer 
   
  case $answer in
      [yY][eE][sS]|[yY])
   echo "Copying $i"
   cp -r "{$i}" "~/.${i}" 
   ;;

      *)
   echo "Skipping $i"
   ;;

  esac

done
