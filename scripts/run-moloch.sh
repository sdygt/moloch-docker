#!/bin/bash
echo "Running run-moloch.sh"
echo ${MOLOCH_ELASTICSEARCH}
/data/wait-for-it.sh ${MOLOCH_ELASTICSEARCH} --timeout=60
if [ $? -ne 0 ]; then
    echo "Exiting." 1>&2
    exit 1
fi

if [ ! -f "/data/.ES_INITED" ]; then
    sed -i -e "s,MOLOCH_ELASTICSEARCH,${MOLOCH_ELASTICSEARCH},g" /data/moloch/etc/config.ini
    /data/moloch/db/db.pl ${MOLOCH_ELASTICSEARCH} init << EOF
INIT
EOF
    touch /data/.ES_INITED
fi

/data/moloch/bin/node viewer.js -c /data/moloch/etc/config.ini