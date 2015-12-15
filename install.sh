#!/bin/sh
#doi voi pfsense 2.1
# setenv  PACKAGESITE http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/i386/packages-8.3-release/Latest/
#hoac
# setenv  PACKAGESITE http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/amd64/packages-8.3-release/Latest/
# pkg_add -r unzip
# rehash
#pfsense 2.3 
#/usr/local/etc/pkg/repos/pfSense.conf
#FreeBSD: {
#  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
#  mirror_type: "srv",
#  enabled: yes
#}

VER=$(cat /etc/version | cut -f 1 -d - | cut -f 1,2 -d .)
if [ $VER == "2.1" ]; then
  if [ $(cat /etc/platform) == "nanobsd" ]; then 
    /etc/rc.conf_mount_rw
  fi
  setenv PACKAGESITE http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/amd64/packages-8.3-release/Latest/
  env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg_add -r unzip nano nload

# If pkg-ng is not yet installed, bootstrap it:
#2.2 or above
else 
  if ! /usr/sbin/pkg -N 2> /dev/null; then
    echo "FreeBSD pkgng not installed. Installing..."
    env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg bootstrap
    env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg update
    env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg install nano nload
    echo " done."
  fi
fi

rehash

cd /tmp/
fetch https://codeload.github.com/thanhdiepts/tdcr-xmlbk-2.2/zip/master
unzip master
cp -rf /tmp/tdcr-xmlbk-2.2-master/* /
rm -f /tmp/master 
rm -rf /tmp/tdcr-xmlbk-2.2-master
chmod +x /root/checkip.sh /root/cloudbk.sh /root/initcloudbk.sh
cp /root/initcloudbk.sh /usr/local/etc/rc.d/

if [ $(/usr/bin/grep -c checkip /etc/crontab) -eq 0 ]; then
  echo "*/15    *       *       *       *       root    /usr/bin/nice -n20 /root/checkip.sh" >> /etc/crontab
  echo "" >> /etc/crontab
fi
if [ $(/usr/bin/grep -c cloudbk /etc/crontab) -eq 0 ]; then
  echo "1       21      *       *       6       root    /usr/bin/nice -n20 /root/cloudbk.sh" >> /etc/crontab
  echo "" >> /etc/crontab
fi

pkill cron
/usr/sbin/cron -s &

cd /root/
sh checkip.sh
sh cloudbk.sh
