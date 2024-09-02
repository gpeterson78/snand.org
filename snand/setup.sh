#!/bin/sh
# setup Script for snand.org.
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# this is hugely work in progress and I'm sure it is essentially worst practice.
#
# Last Updated: 2024-09-02
#
#prepare environment
sudo mkdir -p /snand/scripts
# download scripts and mark them executable:
sudo wget -P /snand/scripts/ https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/wordpress/genenv.sh
sudo chmod +x /snand/scripts/genenv.sh