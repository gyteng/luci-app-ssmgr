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
  address=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","address"\]' | awk '{print $2}')
  port=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","port"\]' | awk '{print $2}')
  password=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","password"\]' | awk '{print $2}')
  method=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["default","method"\]' | awk '{print $2}')
  uci set shadowsocks-libev.@shadowsocks-libev[0].server=${address//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].server_port=${port//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].password=${password//\"/}
  uci set shadowsocks-libev.@shadowsocks-libev[0].encrypt_method=${method//\"/}
  uci commit shadowsocks-libev
  stop=0
  i=1
  uci del ssmgr.@ssmgr[0].server_list
  while [ $stop -eq 0 ]
  do
    server=$(cat ${accountFile} | ./JSON.sh -l | egrep '\["servers",'+$i+',"address"\]' | awk '{print $2}')
    if [ -z "$server" ]; then
      stop=1
    else
      uci add_list ssmgr.@ssmgr[0].server_list=${server//\"/}
      let i+=1
    fi
  done
  uci commit ssmgr
  /etc/init.d/shadowsocks-libev restart
fi
