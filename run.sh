#!/bin/bash

#
# This repo was created when I found this blog
# http://spencer.gibb.us/blog/2014/02/03/introducing-battleschool/
# and thought it's a good idea to automate the install/config of my mac book
#

PROG="`basename $0`"

SETUP_LOCAL_CONFIG="FALSE"
USE_LOCAL_CONFIG="FALSE"
INSTALL_ALL_AS_DEFAULT="FALSE"
YML_CONFIG_URL="https://raw.githubusercontent.com/dieple/ansible-mac-dev-local-setup/master/config.yml"
LOCAL_CONFIG_FILE="~/.battleschool/config.yml"
TEST_MODE="FALSE"

usage()
{
	echo ""
	echo "Usage: $PROG [options]"
	echo ""
	echo "[-a All] Install all packages from default URL config file"
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
  echo "and choose the package to install then re-run"
  echo "$PROG with the -l option"
	echo ""
}

check_prerequites()
{
  # uncomment the following if not already installed
  #sudo easy_install pip
  if which ansible >/dev/null; then
    echo "ansible already installed..."
  else
    echo "installing ansible"
    sudo pip install ansible --quiet
  fi
}


###
# Main program
###

while getopts "alst?" 2> /dev/null ARG
do
	case $ARG in

		a)  INSTALL_ALL_AS_DEFAULT="TRUE";;

    l)  USE_LOCAL_CONFIG="TRUE";;

		s)	SETUP_LOCAL_CONFIG="TRUE";;

		t)	TEST_MODE="TRUE";;

		?)	usage
			exit 1;;
	esac
done

if [ $TEST_MODE = "TRUE" ]
then
	YML_CONFIG_URL="https://raw.githubusercontent.com/dieple/ansible-mac-dev-local-setup/master/test-config.yml"
fi

if [ $SETUP_LOCAL_CONFIG = "FALSE" ] && [ $USE_LOCAL_CONFIG = "FALSE" ] && [ $INSTALL_ALL_AS_DEFAULT = "FALSE" ]
then
	echo "One of the option 'a' or 'l' or 's' must be TRUE to run"
	usage
	exit 1
fi

if [ "$INSTALL_ALL_AS_DEFAULT" = "TRUE" ]; then
	echo "1"
  check_prerequites
  sudo pip install battleschool && battle --ask-sudo-pass --config-file=$YML_CONFIG_URL
elif [ "$SETUP_LOCAL_CONFIG" = "TRUE" ]; then
  if [ ! -d ~/.battleschool ]; then
		echo "2"
    mkdir ~/.battleschool
	fi
	echo "3"
	cd .battleschool
  curl -L $YML_CONFIG_URL > $LOCAL_CONFIG_FILE
  setup_config_info
  exit 0
else # run with local config
	echo "4"
	if [ ! -f $LOCAL_CONFIG_FILE ]; then
		echo "5"
		"echo `basename $LOCAL_CONFIG_FILE` does not exist"
    "echo run $0 with -s option to set it up first"
		exit 1
	fi
	echo "6"
  check_prerequites
  sudo pip install battleschool && battle --ask-sudo-pass
fi

###
# END
###
