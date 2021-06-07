#!/bin/sh

rewards=$(bcnad query distribution commission bcnavaloper19xxs503q3xe6p20tngk4qa8shlp47973udwysk | sed 's/,/\n/g' | grep "amount" | sed 's/:/\n/g' | sed 's/\"//g' | sed '1d' | sed 's/}//g')
echo $rewards
minnum=1000000
numtemp=$(echo "$rewards >$minnum" |bc)
if [ 1 -gt $numtemp ]
then
    bcnad tx distribution withdraw-all-rewards --from suzumiya2014 --chain-id bitcanna-testnet-2 --gas-prices 0.01ubcna --yes
fi

amount=$(bcnad query bank balances bcna19xxs503q3xe6p20tngk4qa8shlp479739sly2z | sed 's/,/\n/g' | grep "amount" | sed 's/:/\n/g' | sed 's/\"//g' | sed '1d' | sed 's/}//g')
echo $amount

minnum=1000000
staynum=100000
tempdaric=ubcna
delegatenum=$(expr $amount - $staynum)
echo $delegatenum
delegateprice=$delegatenum$tempdaric

if [ ${amount} -gt $minnum ] 
then
    bcnad tx staking delegate bcnavaloper19xxs503q3xe6p20tngk4qa8shlp47973udwysk $delegateprice --from suzumiya2014 --chain-id bitcanna-testnet-2 --gas-prices 0.01ubcna --yes
    break
fi
