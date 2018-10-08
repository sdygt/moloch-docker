#!/bin/bash
if [ ! -f "/data/.ES_INITED" ];then
    sed -i -e "s,MOLOCH_ELASTICSEARCH,${MOLOCH_ELASTICSEARCH},g" /data/moloch/etc/config.ini
    /data/moloch/db/db.pl ${MOLOCH_ELASTICSEARCH} init
    touch /data/.ES_INITED
fi

/data/moloch/bin/node viewer.js -c /data/moloch/etc/config.ini