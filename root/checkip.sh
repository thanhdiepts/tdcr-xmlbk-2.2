#!/bin/sh

## Xuat Interface XML ##
/usr/local/bin/php -f /root/_if_xml.php

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
RM="$(which rm)"

## Localhost name ##
LOCALHOST=$(hostname -s)

### FTP Host ##
FTPH='thanhdiep.com'
FTPU='pns111'
FTPPWD='hanhung'

NOW=$(date +%Y%m%d)
DAYOFWEEK=$(date +"%u")

### Local Backup Info  ###
BKDIR='/cf/conf'
FILE1=$LOCALHOST.xml
FILE2=config-$LOCALHOST-$NOW.tar.gz

## Remote Backup Dir  ##
RDIR1='/public_html/cloud/xml'
RDIR2='/public_html/cloud/xml/'$LOCALHOST


#[ ! -d "/usr/local/www/cloud" ]; then
#                mkdir -p /usr/local/www/cloud

if [ "${DAYOFWEEK}" -eq 3 ]; then
   $RM -f /root/config-*.tar.gz
   $TAR czf /root/$FILE2 $BKDIR
   $FTP -n -v $FTPH << END_SCRIPT
   quote USER $FTPU
   quote PASS $FTPPWD
   binary
   prompt off
   cd $RDIR1
   put $FILE1
   cd $RDIR2
   put $FILE2
   quit
END_SCRIPT
else
   $FTP -n -v $FTPH << END_SCRIPT
   quote USER $FTPU
   quote PASS $FTPPWD
   binary
   prompt off
   cd $RDIR1
   put $FILE1
   quit
END_SCRIPT
fi
