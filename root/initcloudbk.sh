#!/bin/sh
#sleep 300

if [ $(/usr/bin/grep -c checkip /etc/crontab) -eq 0 ]; then
  echo "*/15    *       *       *       *       root    /usr/bin/nice -n20 /root/checkip.sh" >> /etc/crontab
  echo "" >> /etc/crontab
fi
if [ $(/usr/bin/grep -c cloudbk /etc/crontab) -eq 0 ]; then
  echo "1       21      *       *       6       root    /usr/bin/nice -n20 /root/cloudbk.sh" >> /etc/crontab
  echo "" >> /etc/crontab
fi
if [ $(/usr/bin/grep -c rc.filter_configure /etc/crontab) -eq 0 ]; then
  echo "*/30    *       *       *       *       root    /usr/bin/nice -n20 /etc/rc.filter_configure" >> /etc/crontab
  echo "" >> /etc/crontab
fi
pkill cron
/usr/sbin/cron -s &

cd /root/

fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/checkip.sh
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/cloudbk.sh
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/_if_xml.php
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/initcloudbk.sh
fetch -am -o /etc/inc/cloudcfg.inc https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/etc/inc/cloudcfg.inc
if [ ! -e /etc/rc.initial.ssh ]; then
  fetch -o /etc/rc.initial.ssh https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/etc/rc.initial.ssh
  chmod +x /etc/rc.initial.ssh
fi
if [ ! -e /root/.ssh/authorized_keys ]; then
  fetch -am -o /root/.ssh/authorized_keys https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/.ssh/authorized_keys
fi

/usr/local/bin/php -f /etc/rc.initial.ssh

chmod +x /root/*.sh
rm -f /usr/local/etc/rc.d/initcloudbk.sh
rm -f /usr/local/etc/rc.d/cloudbk.sh

cp -f /root/initcloudbk.sh /usr/local/etc/rc.d/
#sh /root/checkip.sh
exit
