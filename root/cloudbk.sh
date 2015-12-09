#!/bin/sh
sleep 5m
. /etc/inc/cloud

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
RM="$(which rm)"

## Localhost name ##
LOCALHOST=$(hostname -s)
NOW=$(date +%Y%m%d)
DAYOFWEEK=$(date +"%u")

### Local Backup Info  ###
BKDIR='/cf/conf'
FILE2=config-$LOCALHOST-$NOW.tar.gz

## Remote Backup Dir  ##
RDIR2='/public_html/cloud/xml/'$LOCALHOST

cd /root/

#[ ! -d "/usr/local/www/cloud" ]; then
#                mkdir -p /usr/local/www/cloud
if [ "${DAYOFWEEK}" -eq 6 ]; then
   $RM -f /root/config-*.tar.gz
   $TAR czf /root/$FILE2 $BKDIR
   $FTP -n -v $FTPH << END_SCRIPT
   quote USER $FTPU
   quote PASS $FTPPWD
   binary
   prompt off
   cd $RDIR2
   put $FILE2
   quit
END_SCRIPT
fi
