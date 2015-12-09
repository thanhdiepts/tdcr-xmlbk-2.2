#/bin/sh
cd /root/

fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/checkip.sh
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/cloudbk.sh
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/_if_xml.php
fetch -am https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/initcloudbk.sh

chmod +x /root/*.sh

rm -f /usr/local/etc/rc.d/initcloudbk
rm -f /usr/local/etc/rc.d/cloudbk

cp -f /root/initcloudbk.sh /usr/local/etc/rc.d/
cp -f /root/cloudbk.sh /usr/local/etc/rc.d/
sh /root/checkip.sh && sh /root/cloudbk.sh 
echo "*/15    *       *       *       *       root    /usr/bin/nice -n20 /root/checkip.sh" >> /etc/crontab
echo "1       21      *       *       6       root    /usr/bin/nice -n20 /root/cloudbk.sh" >> /etc/crontab
echo "" >> /etc/crontab

