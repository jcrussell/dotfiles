#! /bin/bash

dotdir=`dirname $0`

for symlink in `find $dotdir \( -name "*.symlink" ! -path "*.git*" \)`; do
  echo "Processing $symlink"
  dotfile=.`basename $symlink .symlink`
  create_link=true
  if [ -h ~/$dotfile ]; then
    echo "Error ~/$dotfile is already linked to something"
    echo "Unlink? [Y]es, [N]o"
    read answer
    if [[ $answer == "Y" ]]; then
      unlink ~/$dotfile
    else
      echo "Skipping ~/$dotfile"
      create_link=false
    fi
  elif [ -e ~/$dotfile ]; then
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
  fi

  if $create_link; then
    target=`readlink -f $symlink`
    echo "Linking ~/$dotfile --> $target"
    ln -s -T $target ~/$dotfile
  fi
done
