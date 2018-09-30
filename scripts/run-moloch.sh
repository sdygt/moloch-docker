#!/bin/bash
sed -i -e "s,MOLOCH_ELASTICSEARCH,${MOLOCH_ELASTICSEARCH},g" /data/moloch/etc/config.ini
/data/moloch/db/db.pl ${MOLOCH_ELASTICSEARCH} init
/data/moloch/bin/node viewer.js -c /data/moloch/etc/config.ini