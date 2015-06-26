#!/usr/bin/env bash

INSTALL_SH_VERSION="0.0.3"
INSTALL_SH_CONF_DIR=${HOME}/.install.sh
PKGSH_FILE="pkgsh.json"
JSON_PARSER=${INSTALL_SH_CONF_DIR}/tools/jq

function install.sh {
  local cmd=$1;

  # Show help info if call install.sh
  # without any arguments
  if [ -z "$cmd" ]; then
      if [ -f "$PKGSH_FILE" ]; then
        _installsh_install_packages;
      else
        _installsh_help;
      fi

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

function _installsh_install_packages {
  local packages=$(cat $PKGSH_FILE |$JSON_PARSER .packages[])

  for package in $packages
  do
      local pkg=$(echo $package | sed 's/\"//g')
      _install_project $pkg;
  done

}

function _install_project {
  local cmd=$1;
  local args=${@:2};
  local url=${INSTALL_SH_URL:-'http://install.opensource.sh'}
  bash <(curl -sL ${url}/${cmd}) $args
}

function _installsh_version {
  echo
  echo "install.sh version ${INSTALL_SH_VERSION}"
}

function _installsh_selfupdate {
  local repo_version=$(curl -s curl -s https://raw.githubusercontent.com/mignev/install.sh/master/install.sh |grep '^INSTALL_SH_VERSION='| awk -F\" '{print $(NF-1)}')
  local my_installation_version=$INSTALL_SH_VERSION;
  if [ "$repo_version" != "$my_installation_version" ]; then
    rm -rf ~/.install.sh
    _install_project mignev/install.sh --without-bashrc-update
    source ~/.install.sh/install.sh
  else
    echo
    echo "Your install.sh is up-to-date.";
  fi


  return 0;
}
