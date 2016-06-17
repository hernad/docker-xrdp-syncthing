#!/bin/bash

SYNCTHING_USER=dockerx

chown -R $SYNCTHING_USER:$SUNCTHING_USER /home/$SYNCTHING_USER

# if this if the first run, generate a useful config
[ -f /syncthing/config/config.xml ] && exit 0


CONFIG=/syncthing/config/config.xml

echo "generating config"
/syncthing/bin/syncthing --generate="/syncthing/config"
# don't take the whole volume with the default so that we can add additional folders
sed -e "s/id=\"default\" path=\"\/root\/Sync\/\"/id=\"default\" path=\"\/home\/$SYNCTHING_USER\/syncthing_default\/\"/" -i $CONFIG

# ensure we can see the web ui outside of the docker container
sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8384/" -i $CONFIG

chown $SYNCTHING_USER.users -R /syncthing

