#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

if [ -z "$1" ]; then
        ADAYAGO=`date --date="1 day ago" +%Y-%m-%d`
else
        ADAYAGO="$1"
fi

echo "Starting $ADAYAGO"
QUERY_STR='{"query":{"range":{"timestamp":{"gte":"'"$ADAYAGO "'00:00:00.000","lte":"'"$ADAYAGO"' 23:59:59.999"}}}}'
EXPORT_PATH=/logs/exports/elasticsearch/
EXPORT_FILE_NAME=esbackup.$ADAYAGO.json
es-export-bulk --url http://localhost:9200 --file $EXPORT_PATH/$EXPORT_FILE_NAME --body "$QUERY_STR"
ls -lh $EXPORT_PATH/$EXPORT_FILE_NAME
gzip -9 $EXPORT_PATH/$EXPORT_FILE_NAME
md5sum $EXPORT_PATH/$EXPORT_FILE_NAME.gz > $EXPORT_PATH/$EXPORT_FILE_NAME.gz.hash
sha1sum $EXPORT_PATH/$EXPORT_FILE_NAME.gz >> $EXPORT_PATH/$EXPORT_FILE_NAME.gz.hash
sha256sum $EXPORT_PATH/$EXPORT_FILE_NAME.gz >> $EXPORT_PATH/$EXPORT_FILE_NAME.gz.hash

cd $EXPORT_PATH
/usr/bin/java -jar /usr/local/sbin/tss-client-console-3.1.5.jar -Z $EXPORT_FILE_NAME.gz.hash http://zd.kamusm.gov.tr 80 19006 SIFREYI_GONDERECEGIM &
/usr/bin/java -jar /usr/local/sbin/tss-client-console-3.1.5.jar -K http://zd.kamusm.gov.tr 80 19006 Şifre >> /logs/exports/kalan_kredi
cd -

sleep 5
ls -lh $EXPORT_PATH/$EXPORT_FILE_NAME.*
