#!/usr/bin/env bash
CONFIG_FILE="/root/.neoxacore/neoxa.conf"
url_array=(
    "https://api4.my-ip.io/ip"
    "https://checkip.amazonaws.com"
    "https://api.ipify.org"
)

function get_ip() {
    for url in "$@"; do
        WANIP=$(curl --silent -m 15 "$url" | tr -dc '[:alnum:].')
        # Remove dots from the IP address
        IP_NO_DOTS=$(echo "$WANIP" | tr -d '.')
        # Check if the result is a valid number
        if [[ "$IP_NO_DOTS" != "" && "$IP_NO_DOTS" =~ ^[0-9]+$ ]]; then
            break
        fi
    done
}

if [[ ! -f $CONFIG_FILE ]]; then
    get_ip "${url_array[@]}"
    RPCUSER=$(pwgen -1 18 -n)
    PASSWORD=$(pwgen -1 20 -n)
    echo "rpcuser=$RPCUSER" >> $CONFIG_FILE
    echo "rpcpassword=$PASSWORD" >> $CONFIG_FILE
    echo "rpcallowip=127.0.0.1" >> $CONFIG_FILE
    echo "listen=1" >> $CONFIG_FILE
    echo "server=1" >> $CONFIG_FILE
    echo "daemon=1" >> $CONFIG_FILE
    echo "logtimestamps=1" >> $CONFIG_FILE
    echo "externalip=$WANIP:8788" >> $CONFIG_FILE
    echo "smartnodeblsprivkey=$KEY" >> $CONFIG_FILE
fi

if [[ "$KEY" != "" ]]; then 
    if grep -q "^smartnodeblsprivkey=$" $CONFIG_FILE; then
        sed -i "s/^smartnodeblsprivkey=$/smartnodeblsprivkey=$KEY/" $CONFIG_FILE
    fi
fi

while true; do
 if [[ $(pgrep neoxad) == "" ]]; then 
   neoxad -daemon
 fi
sleep 120
done
