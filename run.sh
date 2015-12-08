#!/bin/bash

IMG=xrdp-syncthing
CT=xrdp-syncthing

docker rm -f $CT
docker run -d \
    -p 8080:8080 -p 3389:3389 \
    --name $CT \
    $IMG

docker exec -ti $CT /bin/bash
