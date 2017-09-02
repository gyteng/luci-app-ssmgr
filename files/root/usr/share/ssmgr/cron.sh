isInCron=`cat /etc/crontabs/root | grep "/usr/share/ssmgr/start.sh" | wc -l`
if [ "$isInCron" == "0" ]; then
  echo "*/3 * * * * sh /usr/share/ssmgr/start.sh" >> /etc/crontabs/root
fi
