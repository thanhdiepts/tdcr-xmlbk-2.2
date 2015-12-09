#/bin/sh
#doi voi pfsense 2.1
# setenv  PACKAGESITE http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/i386/packages-8.3-release/All/
#hoac
# setenv  PACKAGESITE http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/amd64/packages-8.3-release/All/
# pkg_add -r unzip
# rehash
#pfsense 2.3 
#/usr/local/etc/pkg/repos/pfSense.conf
#FreeBSD: {
#  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
#  mirror_type: "srv",
#  enabled: yes
#}


# If pkg-ng is not yet installed, bootstrap it:
if ! /usr/sbin/pkg -N 2> /dev/null; then
  echo "FreeBSD pkgng not installed. Installing..."
  env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg bootstrap
  echo " done."
fi

env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg update
env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg install nano

REHASH=$(which rehash)
$REHASH

cd /tmp/
fetch https://codeload.github.com/thanhdiepts/tdcr-xmlbk-2.2/zip/master
unzip master
cp -rf /tmp/tdcr-xmlbk-2.2-master/* /
rm -f /tmp/master 
rm -rf /tmp/tdcr-xmlbk-2.2-master
chmod +x /root/checkip.sh /root/cloudbk.sh /root/initcloudbk.sh
cp /root/initcloudbk.sh /usr/local/etc/rc.d/
cp /root/cloudbk.sh /usr/local/etc/rc.d/

echo "*/15    *       *       *       *       root    /usr/bin/nice -n20 /root/checkip.sh" >> /etc/crontab
echo "1       21      *       *       6       root    /usr/bin/nice -n20 /root/cloudbk.sh" >> /etc/crontab
echo "" >> /etc/crontab
pkill cron
/usr/sbin/cron -s &

cd /root/
./checkip.sh
./cloudbk.sh
