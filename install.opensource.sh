#!/usr/bin/env bash

function __install_jq {
  local dist=$1
  local tools_dir=~/.install.sh/tools/

  if [ ! -d  "$tools_dir" ]; then
    mkdir -p $tools_dir
  fi

  pushd $tools_dir
    case $dist in
      Linux)
        curl -OL http://stedolan.github.io/jq/download/linux64/jq
        ;;

      Darwin)
        curl -OL http://stedolan.github.io/jq/download/osx64/jq
        ;;
      *) ;;
    esac
    chmod +x jq
  popd
}

if [ -d ~/.install.sh ]; then
  echo ""
  echo 'install.sh is already installed!'
  echo ""
  echo 'If you want to update install.sh, type the following:'
  echo '    install.sh selfupdate'
else
  repo_version=$(curl -s https://raw.githubusercontent.com/mignev/install.sh/master/install.sh |grep '^INSTALL_SH_VERSION='| awk -F\" '{print $(NF-1)}')
  curl -L https://github.com/mignev/install.sh/archive/v$repo_version.tar.gz | tar zx
  install_sh_download_dir=install.sh-$repo_version
  mv $install_sh_download_dir ~/.install.sh

  echo -e "\nsource ~/.install.sh/install.sh" >> ~/.bashrc
  os=`uname`
  __install_jq $os
fi
