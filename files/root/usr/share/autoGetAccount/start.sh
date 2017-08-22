cd /usr/share/autoGetAccount

isEnable=`uci get ssmgr.@ssmgr[0].enable`
if [ "$isEnable" == "0" ]; then
  return
fi

accountFile="./account.txt"
ssmgrAddress=`cat ./website.txt`
macAddress=`ifconfig | grep 'eth0' | awk '{print $5}' | sed 's/\://g'`

if [ ! -f $accountFile ]; then
  touch $accountFile
fi
oldAccount=$(cat $accountFile)
newAccount=$(curl -s ${ssmgrAddress}api/user/account/mac/${macAddress})
if [ "$oldAccount" == "$newAccount" ]
then
  echo 'account not change'
else
  echo $newAccount > $accountFile
  address=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["address"\]' | awk '{print $2}')
  port=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["port"\]' | awk '{print $2}')
  password=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["password"\]' | awk '{print $2}')
  method=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["method"\]' | awk '{print $2}')
  uci set shadowsocks-libev.@shadowsocks-libev[0].server=${address//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].server_port=${port//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].password=${password//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].encrypt_method=${method//\"/}
  uci commit shadowsocks-libev
  /etc/init.d/shadowsocks-libev restart
fi
