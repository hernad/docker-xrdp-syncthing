#!/bin/bash

IMG=xrdp-syncthing
CT=xrdp-syncthing


docker rm -f $CT

# echo /home/dockerx/.config/pulse ne smije biti volumen

docker run -d \
    -p 8080:8080 -p 3389:3389 \
    -v $(pwd)/dockerx/.config/google-chrome:/home/dockerx/.config/google-chrome \
    -v $(pwd)/syncthing/config:/syncthing/config \
    -v $(pwd)/data:/syncthing/data \
    --name $CT \
    $IMG

#-v $(pwd)/dockerx:/home/dockerx \

docker exec -ti $CT /bin/bash
