#!/bin/bash

export COLOR_NC='\e[0m' # No Color
export COLOR_GREEN='\e[0;32m'
export COLOR_RED='\e[0;31m'
bold=$(tput bold)
normal=$(tput sgr0)
echo ""
echo -n "Bee version " ; docker exec NAME_OF_CONTAINER bee version 
echo ""
if pgrep -x "bee" > /dev/null
then
    na=$( curl -s localhost:1635/addresses | jq .ethereum | tr -d '"')
    cba=$(curl -s localhost:1635/chequebook/address | jq .chequebookAddress | tr -d '"')
    echo "Your address: ${bold}$na${normal}"
    echo "  Etherscan https://goerli.etherscan.io/address/$na"
    echo "Your chequebook: ${bold}$cba${normal}"
    echo "  Etherscan https://goerli.etherscan.io/address/$cba"
    echo ""
    echo -n "Peers now: "; curl -s http://localhost:1635/peers | jq '.peers | length'
else
    echo -e "Bee node is ${COLOR_RED}NOT RUNNING! :(${COLOR_NC}"
    read -p "Do you want try to start node? (Yy/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      docker run -d\
      -v /path/to/local/bee:/home/bee/.bee\
      -p 1635:1635 -p 1634:1634 -p 1633:1633\
      --name NAME_OF_CONTAINER\
      --rm -it ethersphere/bee:latest start --config /path/to/config/config.yaml 
      echo "Please, wait 30sec and run this utility again..."
      echo "Good Beee!"
      echo "Bzzz..."
      exit 0
    fi
fi

echo ""
PS3='Please enter your choice:'
options=("Balance" "Manual cashout" "chequebook --gBzz--> node" "chequebook <--gBzz-- node" "Follow logs" "Stop Bee" "Quit")
select opt in "${options[@]}"
do
    case $opt in
    "Balance" )
        echo "Balance of chequebook:"
        curl -s localhost:1635/chequebook/balance
        ;;
    "Manual cashout" )
        echo "Manual cashout (./cashout.sh cashout-all >> /root/cash.log)..."
        ./cashout.sh cashout-all >> ~/cash.log
        ;;
    "chequebook --gBzz--> node" )
        echo "Move gBzz from cheque book to address of node..."
        thash=$(curl -XPOST -s localhost:1635/chequebook/withdraw\?amount\=1000 | jq .transactionHash | tr -d '"')
        echo "  Etherscan https://goerli.etherscan.io/tx/$thash"
        ;;
 	"chequebook <--gBzz-- node" )
        echo "Move gBzz from node's address to cheque book..."
        thash=$(curl -XPOST -s localhost:1635/chequebook/deposit\?amount\=1000 | jq .transactionH$)
        echo "Etherscan https://goerli.etherscan.io/tx/$thash"
        ;;
   "Follow logs")
        echo "Following logs"
        docker logs NAME_OF_CONTAINER -f --tail="15"
        ;;
	"Stop Bee")
        echo "Stoping the swarm"
        docker stop NAME_OF_CONTAINER
        ;;
	"Quit")
        break
        ;;
        *) echo "invalid option $REPLY";;
    esac
done
