#!/bin/bash

################################################################################
MOLOCH_INSTALL_DIR=/data/moloch
MOLOCH_NAME=moloch
if [ -z "$MOLOCH_INTERFACE" ]; then MOLOCH_INTERFACE="eth0"; fi

################################################################################
echo "Moloch - Creating configuration files"
echo sed -e "s/passwordSecret =/# passwordSecret =/g" -e "s/MOLOCH_INTERFACE/${MOLOCH_INTERFACE}/g" -e "s,MOLOCH_INSTALL_DIR,${MOLOCH_INSTALL_DIR},g" < /data/moloch/etc/config.ini.sample > /data/moloch/etc/config.ini
sed -e "s/passwordSecret =/# passwordSecret =/g" -e "s/MOLOCH_INTERFACE/${MOLOCH_INTERFACE}/g" -e "s,MOLOCH_INSTALL_DIR,${MOLOCH_INSTALL_DIR},g" < /data/moloch/etc/config.ini.sample > /data/moloch/etc/config.ini

################################################################################
mkdir -p /data/moloch/logs /data/moloch/raw
chown nobody /data/moloch/logs /data/moloch/raw
chmod 0700 /data/moloch/raw

################################################################################
if [ -d "/etc/logrotate.d" ] && [ ! -f "/etc/logrotate.d/$MOLOCH_NAME" ]; then
    echo "Moloch - Installing /etc/logrotate.d/$MOLOCH_NAME to rotate files after 7 days"
    cat << EOF > /etc/logrotate.d/$MOLOCH_NAME
/data/moloch/logs/capture.log
/data/moloch/logs/viewer.log {
    daily
    rotate 7
    notifempty
    copytruncate
}
EOF
fi

################################################################################
INTERFACES=${MOLOCH_INTERFACE//;/ }
cat << EOF > /data/moloch/bin/moloch_config_interfaces.sh
#!/bin/sh
for interface in $INTERFACES; do
  /sbin/ethtool -G \$interface rx 4096 tx 4096 || true
  for i in rx tx sg tso ufo gso gro lro; do
      /sbin/ethtool -K \$interface \$i off || true
  done
done
EOF
chmod a+x /data/moloch/bin/moloch_config_interfaces.sh

################################################################################
if [ -d "/etc/security/limits.d" ] && [ ! -f "/etc/security/limits.d/99-moloch.conf" ]; then
    echo "Moloch - Installing /etc/security/limits.d/99-moloch.conf to make core and memlock unlimited"
    cat << EOF > /etc/security/limits.d/99-moloch.conf
nobody  -       core    unlimited
root    -       core    unlimited
nobody  -       memlock    unlimited
root    -       memlock    unlimited
EOF
fi

################################################################################
echo "Moloch - Downloading GEO files"
/data/moloch/bin/moloch_update_geo.sh > /dev/null

################################################################################
echo ""
echo "Moloch - Configured"
echo ""
