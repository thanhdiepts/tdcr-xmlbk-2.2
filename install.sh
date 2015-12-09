#/bin/sh
# If pkg-ng is not yet installed, bootstrap it:
if ! /usr/sbin/pkg -N 2> /dev/null; then
  echo "FreeBSD pkgng not installed. Installing..."
  env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg bootstrap
  echo " done."
fi

env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg update
env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg install nano

REHASH=$(which rehash)
FETCH=$(which fetch)
$REHASH

cd /tmp/
$FETCH https://codeload.github.com/thanhdiepts/tdcr-xmlbk-2.2/zip/master
unzip master
cp -rf /tmp/tdcr-xmlbk-2.2-master/* /
rm -f /tmp/master 
rm -rf /tmp/tdcr-xmlbk-2.2-master
chmod +x /root/checkip.sh /root/cloudbk.sh /root/initcloudbk.sh
cp /root/initcloudbk.sh /usr/local/etc/rc.d/
cp /root/cloudbk.sh /usr/local/etc/rc.d/

cd /root/
./checkip.sh
./cloudbk.sh

echo "Cai dat Cron"
echo "pfSsh.php"
echo "playback installpkg Cron"
pfSsh.php
