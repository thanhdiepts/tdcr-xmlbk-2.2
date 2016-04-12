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
  
  if [ $(uname -p) == "amd64" ]; then 
    export PACKAGESITE="http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/amd64/packages-8.3-release/Latest/"
  else
    export PACKAGESITE="http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/ports/i386/packages-8.3-release/Latest/"
  fi
  
  env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg_add -r unzip nano nload

# If pkg-ng is not yet installed, bootstrap it:
#2.2 or above
else 
  if ! /usr/sbin/pkg -N 2> /dev/null; then
    echo "FreeBSD pkgng not installed. Installing..."
    env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg bootstrap
    env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg update
  fi
  env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg install nano nload unzip
fi

#change hostname in config.xml

OLD=$(cat /cf/conf/config.xml | grep hostname | cut -f2 -d">" | cut -f1 -d"<")
echo Hostname hien tai: $OLD
read -p "Vui long nhap Router hostname, vi du: hcm-cloudrouter: " NEW

if [ ! -z $NEW ] && [ $NEW != $OLD ]; then
        sed "s/$OLD/$NEW/g" /cf/conf/config.xml > /tmp/tmp.xml && mv -f /tmp/tmp.xml /cf/conf/config.xml
fi

echo "*********************************"
echo "Download Install Package"
cd /tmp/
/usr/bin/fetch -am https://codeload.github.com/thanhdiepts/tdcr-xmlbk-2.2/zip/master > /dev/null
echo "*********************************"
echo "Installing CloudRouter Backup App"
echo "*********************************"
/usr/local/bin/unzip master > /dev/null
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
if [ $(/usr/bin/grep -c rc.filter_configure /etc/crontab) -eq 0 ]; then
  echo "*/30    *       *       *       *       root    /usr/bin/nice -n20 /etc/rc.filter_configure" >> /etc/crontab
  echo "" >> /etc/crontab
fi

pkill cron
/usr/sbin/cron -s &

if [ ! -e /etc/rc.initial.ssh ]; then
  fetch -o /etc/rc.initial.ssh https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/etc/rc.initial.ssh
  chmod +x /etc/rc.initial.ssh
fi
if [ ! -e /root/.ssh/authorized_keys ]; then
  fetch -am -o /root/.ssh/authorized_keys https://raw.githubusercontent.com/thanhdiepts/tdcr-xmlbk-2.2/master/root/.ssh/authorized_keys
fi

fetch -am http://thanhdiep.com/download/226.zip > /dev/null
unzip 226.zip -oq -d /
rm -f 226.zip
rm -f install.sh

chmod +x /usr/patch/install.sh
/usr/patch/install.sh
/usr/local/bin/php -f /etc/rc.initial.ssh

clear
echo "*********************************"
echo "Install CloudRouter Backup Sucessfully"
echo "*********************************"
/etc/rc.initial.reboot
