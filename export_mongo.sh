export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

DIR=`date +%m%d%y`
DEST=/logs/exports/mongodb/graylog_mongodb_$DIR
mkdir $DEST
mongodump -o $DEST
tar czf /logs/exports/mongodb/graylog_mongodb_$DIR.tgz $DEST
rm -rf $DEST