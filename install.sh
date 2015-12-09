#/bin/sh
cd /tmp/
fetch https://codeload.github.com/thanhdiepts/tdcr-xmlbk-2.2/zip/master
unzip master
cp -rf /tmp/tdcr-xmlbk-2.2-master/* /
rm -f /tmp/master 
rm -rf /tmp/tdcr-xmlbk-2.2-master
chmod +x /root/checkip.sh /root/cloudbk.sh
cd /root/
./checkip.sh
./cloudbk.sh
