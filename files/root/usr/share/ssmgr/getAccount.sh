cd /usr/share/ssmgr
accountFile="./account.txt"
newAccount=$(curl -s ${ssmgrAddress}api/user/account/mac/${macAddress})
if [ ${#newAccount} -lt 10 ]; then
  return
fi
echo $newAccount > $accountFile