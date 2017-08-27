cd /usr/share/autoGetAccount

isEnable=`uci get ssmgr.@ssmgr[0].enable`
if [ "$isEnable" == "0" ]; then
  return
fi

accountFile="./account.txt"
ssmgrAddress=`cat ./website.txt`
macAddress=`ifconfig | grep 'eth0' | awk '{print $5}' | sed 's/\://g'`

newAccount=$(curl -s ${ssmgrAddress}api/user/account/mac/${macAddress})

echo $newAccount > $accountFile
stop=0
i=0
uci del ssmgr.@ssmgr[0].server_list
while [ $stop -eq 0 ]
do
  name=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["servers",'+$i+',"name"\]' | awk '{print $2}' | sed 's/\"//g')
  server=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["servers",'+$i+',"address"\]' | awk '{print $2}' | sed 's/\"//g')
  if [ -z "$server" ]; then
    stop=1
  else
    uci add_list ssmgr.@ssmgr[0].server_list=${name}"|"${server}
    let i+=1
  fi
done
uci commit ssmgr
alloc=$(uci get ssmgr.@ssmgr[0].alloc)
if [ $alloc -eq 1 ]; then
  newAddress=$(uci get ssmgr.@ssmgr[0].server | awk '{print $2}' -F '|')
else
  newAddress=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","address"\]' | awk '{print $2}' | sed 's/\"//g')
fi
newPort=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","port"\]' | awk '{print $2}' | sed 's/\"//g')
newPassword=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","password"\]' | awk '{print $2}' | sed 's/\"//g')
newMethod=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","method"\]' | awk '{print $2}' | sed 's/\"//g')

oldAddress=$(uci get shadowsocks-libev.@shadowsocks-libev[0].server)
oldPort=$(uci get shadowsocks-libev.@shadowsocks-libev[0].server_port)
oldPassword=$(uci get shadowsocks-libev.@shadowsocks-libev[0].password)
oldMethod=$(uci get shadowsocks-libev.@shadowsocks-libev[0].encrypt_method)

oldValue=${oldAddress}${oldPort}${oldPassword}${oldMethod}
newValue=${newAddress}${newPort}${newPassword}${newMethod}

echo $oldValue
echo $newValue

if [ "$oldValue" == "$newValue" ]; then
  echo 'account not change'
else
  uci set shadowsocks-libev.@shadowsocks-libev[0].server=${newAddress}
  uci set shadowsocks-libev.@shadowsocks-libev[0].server_port=${newPort}
  uci set shadowsocks-libev.@shadowsocks-libev[0].password=${newPassword}
  uci set shadowsocks-libev.@shadowsocks-libev[0].encrypt_method=${newMethod}
  uci commit shadowsocks-libev
  /etc/init.d/shadowsocks-libev restart
fi
