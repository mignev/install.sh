#!/usr/bin/env bash
bash - << EOF
if [ -d ~/.install.sh ]; then
  echo ""
  echo 'install.sh is already installed!'
  echo ""
  echo 'If you want to update install.sh, type the following:'
  echo '    install.sh selfupdate'
else
  git clone https://github.com/mignev/install.sh.git ~/.install.sh
  echo -e "\nsource ~/.install.sh/install.sh" >> ~/.bashrc
fi
EOF
