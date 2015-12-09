#!/bin/sh

## Xuat Interface XML ##
/usr/local/bin/php -f /root/_if_xml.php
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
FILE1=$LOCALHOST.xml


## Remote Backup Dir  ##
RDIR1='/public_html/cloud/xml'
cd /root/
#[ ! -d "/usr/local/www/cloud" ]; then
#                mkdir -p /usr/local/www/cloud

#if [ "${DAYOFWEEK}" -eq 3 ]; then
   $FTP -n -v $FTPH << END_SCRIPT
   quote USER $FTPU
   quote PASS $FTPPWD
   binary
   prompt off
   cd $RDIR1
   put $FILE1
   quit
END_SCRIPT
#fi


