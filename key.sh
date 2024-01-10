#!/bin/bash
CONFIG_FILE="/root/.neoxacore/neoxa.conf"
KEY_PLACEHOLDER="smartnodeblsprivkey"
sed -i "/^$KEY_PLACEHOLDER/d" "$CONFIG_FILE"
echo "$KEY_PLACEHOLDER=$1" >> $CONFIG_FILE
echo -e "[NEW] ${KEY_PLACEHOLDER} created - $1"
echo -e ""
