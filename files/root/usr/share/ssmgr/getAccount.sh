cd /usr/share/ssmgr
accountFile="./account.txt"
ssmgrAddress=$(uci get ssmgr.@ssmgr[0].site)
macAddress=`ifconfig | grep 'eth0' | awk '{print $5}' | sed 's/\://g'`
newAccount=$(curl -s ${ssmgrAddress}api/user/account/mac/${macAddress})
if [ ${#newAccount} -lt 10 ]; then
  return
fi
echo $newAccount > $accountFile