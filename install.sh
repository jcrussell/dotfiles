#! /bin/bash

dotdir=`dirname $0`

for symlink in `find $dotdir \( -iname "*.symlink" ! -iname ".*" \)`; do
  echo "Processing $symlink"
  dotfile=.`basename $symlink .symlink`
  create_link=true
  if [ -e ~/$dotfile ]; then
    echo "Error ~/$dotfile already exists"
    echo "What should be done? [B]ackup, [S]kip"
    read answer
    if [[ $answer == "B" ]]; then
      echo "Backing up ~/$dotfile to ~/.dotfiles.bak/$dotfile"
      mkdir -p ~/.dotfiles.bak
      mv ~/$dotfile ~/.dotfiles.bak/
    else
      echo "Skipping ~/$dotfile"
      create_link=false
    fi
  elif [ -h ~/$dotfile ]; then
    echo "Error ~/$dotfile is already linked to something"
    echo "Unlink? [Y]es, [N]o"
    read answer
    if [[ $answer == "Y" ]]; then
      unlink ~/$dotfile
    else
      echo "Skipping ~/$dotfile"
      create_link=false
    fi
  fi

  if $create_link; then
    echo "Linking ~/$dotfile --> `pwd`$symlink"
    ln -s -T `pwd`/$symlink ~/$dotfile
  fi
done
