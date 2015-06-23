#!/usr/bin/env bash

INSTALL_SH_VERSION="0.0.1"
INSTALL_SH_CONF_DIR=${HOME}/.install.sh

function install.sh {
  local cmd=$1;

  # Show help info if call install.sh
  # without any arguments
  if [ -z "$cmd" ]; then
      _installsh_help;
      return 0;
  fi

  case "$cmd" in
    help|-h|--help)
      _installsh_help;
      return 0;
    ;;

    selfupdate)
      _installsh_selfupdate;
      return 0;
    ;;

    version|-v|--version)
      _installsh_version;
      return 0;
    ;;

    *)
      _install_project $@;
      return 0;
    ;;

  esac

}

function _installsh_help {
  echo "usage: install.sh <command>"
}

function _install_project {
  local cmd=$1;
  local args=${@:2};
  echo "Command: ${cmd} with args ${args}"
}

function _installsh_version {
  echo
  echo "install.sh version ${INSTALL_SH_VERSION}"
}

function _installsh_selfupdate {
  local repo_version=$(curl -s https://raw.github.com/mignev/install.sh/master/install.sh |grep '^INSTALL_SH_VERSION='| awk -F\" '{print $(NF-1)}')
  local my_installation_version=$INSTALL_SH_VERSION;
  if [ "$repo_version" != "$my_installation_version" ]; then
    git clone https://github.com/mignev/install.sh.git ~/install.sh
    rm -rf ~/.install.sh
    mv ~/install.sh ~/.install.sh
    source ~/.install.sh/install.sh
  else
    echo
    echo "Your install.sh is up-to-date.";
  fi


  return 0;
}
