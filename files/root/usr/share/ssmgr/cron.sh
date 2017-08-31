isInCron=`cat /etc/crontabs/root | grep "/usr/share/ssmgr/getAccount.sh" | wc -l`
if [ "$isInCron" == "0" ]; then
  echo "*/3 * * * * sh /usr/share/ssmgr/getAccount.sh" >> /etc/crontabs/root
fi
