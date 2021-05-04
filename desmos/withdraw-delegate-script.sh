#!/bin/sh

rewards=$(desmos query distribution commission <desmosvaloper....> | sed 's/,/\n/g' | grep "amount" | sed 's/:/\n/g' | sed 's/\"//g' | sed '1d' | sed 's/}//g')
echo $rewards
minnum=1000000
numtemp=$(echo "$rewards >$minnum" |bc)
if [ 1 -gt $numtemp ]
then
    desmos tx distribution withdraw-all-rewards --from <your wallet moniter> --chain-id morpheus-apollo-1 --gas-prices 0.025udaric --yes
fi

amount=$(desmos query bank balances <desmos1....> | sed 's/,/\n/g' | grep "amount" | sed 's/:/\n/g' | sed 's/\"//g' | sed '1d' | sed 's/}//g')
echo $amount

minnum=1000000
staynum=100000
tempdaric=udaric
delegatenum=$(expr $amount - $staynum)
echo $delegatenum
delegateprice=$delegatenum$tempdaric

if [ ${amount} -gt $minnum ] 
then
    desmos tx staking delegate <desmosvaloper....> $delegateprice --from <your wallet moniter> --chain-id morpheus-apollo-1 --gas-prices 0.025udaric --yes
    break
fi
