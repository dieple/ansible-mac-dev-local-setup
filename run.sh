#!/bin/bash

#
# This repo was created when I found this blog
# http://spencer.gibb.us/blog/2014/02/03/introducing-battleschool/
# and thought it's good idea to automate the install/config of my mac book
#

SETUP_LOCAL_CONFIG="FALSE"
USE_LOCAL_CONFIG="FALSE"
INSTALL_ALL_AS_DEFAULT="TRUE"
PROG="`basename $0`"
YML_CONFIG_URL="https://db.tt/aG2uyydU"
LOCAL_CONFIG_FILE="~/.battleschool/config.yml"


usage()
{
	echo ""
	echo "Usage: $PROG [options]"
	echo ""
  echo "[-l Local] Use local ~/.battleschool/config.yml file"
  echo ""
  echo "[-s setup]  Setup local config.yml file first"
	echo ""
  echo "[-t Test mode] Test mode during development"
  echo ""
}

setup_config_info()
{
	echo ""
  echo "Edit the file ~/.battleschool/config.yml"
  echo "to choose the package to install then re-run"
  echo "$PROG with the -s option"
	echo ""
}

check_prerequites()
{
  # uncomment the following if not already installed
  #sudo easy_install pip
  if which ansible >/dev/null; then
    echo "ansible exists..."
  else
    echo "installing ansible"
    sudo pip install ansible --quiet
  fi
}


###
# Main program
###

while getopts "lst?" 2> /dev/null ARG
do
	case $ARG in

    l)  USE_LOCAL_CONFIG="TRUE"
        INSTALL_ALL_AS_DEFAULT="FALSE";;

		s)	SETUP_LOCAL_CONFIG="TRUE"
        INSTALL_ALL_AS_DEFAULT="FALSE";;

		?)	usage
			exit 1;;
	esac
done



if [ "INSTALL_ALL_AS_DEFAULT" = "TRUE" ]
then
  check_prerequites
  sudo pip install battleschool && battle --ask-sudo-pass --config-file=$YML_CONFIG_URL
elif [ "SETUP_LOCAL_CONFIG" = "TRUE" ]
  # check LOCAL
  if [ -f $LOCAL_CONFIG_FILE ]
  then
    mkdir ~/.battleschool
    cd .battleschool
    curl -L $YML_CONFIG_URL > $LOCAL_CONFIG_FILE
    setup_config_info
    exit 0
  else
    "echo `basename $LOCAL_CONFIG_FILE` does not exist"
    "echo run $0 with -s option to set it up first"
  fi
else # run with local config
  check_prerequites
  sudo pip install battleschool && battle --ask-sudo-pass
fi

###
# END
###
