#!/bin/bash

#########################################################
#	Author: Ashraful Islam <ashraf@iashraful.me>		#
#   Github: https://github.com/iamashraful				#
#	NOTE: This small script will only work for Ubuntu	#
#		and Ubuntu flavors system like Linux mint,		#
#		Xubuntu, Kubuntu etc... 						#
#														#
#					|| Author Speech ||					#
#	This script is for no harm. I'have written for my	#
#	personal use. As per licensing policy everyone can	#
#	update it for their personal use. 					#
#														#
#				|| Developer Notice ||					#
#	Anyone can send PR to it's repository. I'am 		#
# 	expecting Bug, Suggesstion and motivation to 		#
#	something new. Good Luck :)							#
#########################################################

#!/bin/bash

## temp-file for downloading packs
temp_dir=$(mktemp)

## update system
sudo apt update
sudo apt -y upgrade

## install packs
sudo apt -y install git gcc perl make firefox curl apt-transport-https ca-certificates software-properties-common filezilla python3-dev python3-pip build-essentials

## install nodejs
wget -qO - https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "" > ~/.profile
echo "export PATH=~/.npm-global/bin:\$PATH" > ~/.profile
source ~/.profile

## install Visual Studio Code
wget -O $temp_dir https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i $temp_dir
sudo apt-get install -f

## install Google Chrome
wget -O temp_dir https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i $temp_dir
sudo apt-get install -f

## clean up
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y autoclean