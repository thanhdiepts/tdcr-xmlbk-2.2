#/bin/sh
cd /root/
fetch https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/checkip.sh
fetch https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/cloudbk.sh
fetch https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/_if_xml.php
fetch https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/initcloudbk.sh
chmod +x /root/checkip.sh /root/cloudbk.sh /root/initcloudbk.sh
ln -sf /root/initcloudbk.sh /usr/local/etc/rc.d/initcloudbk
ln -sf /root/cloudbk.sh /usr/local/etc/rc.d/cloudbk
sh /root/checkip.sh && sh /root/cloudbk.sh 
echo "*/15    *       *       *       *       root    /usr/bin/nice -n20 /root/checkip.sh" >> /etc/crontab
echo "1       21      *       *       6       root    /usr/bin/nice -n20 /root/cloudbk.sh" >> /etc/crontab
echo "" >> /etc/crontab

