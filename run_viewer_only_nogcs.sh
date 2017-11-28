#!/bin/bash

set -x

PROGNAME=$(basename "$0")

if [ "$#" -ne 1 ]; then
	echo "Usage: ./$PROGNAME <quip-viewer version>"
	exit 1;
fi

echo "Removing existing containers"
docker rm -f quip-viewer

echo "Starting Containers..."

VERSION=1.0
VIEWER_VERSION=$1

STORAGE_FOLDER=$PWD/data

docker network create quip_nw

IMAGES_DIR=$(echo $STORAGE_FOLDER/img)
DATABASE_DIR=$(echo $STORAGE_FOLDER/data)

mkdir -p $IMAGES_DIR 
mkdir -p $DATABASE_DIR

VIEWER_PORT=80
IMAGELOADER_PORT=6002
FINDAPI_PORT=3000

data_host="http://quip-data:9099"
mongo_host="quip-data"
mongo_port=27017

\cp -rf configs $STORAGE_FOLDER/.
CONFIGS_DIR=$(echo $STORAGE_FOLDER/configs)

## Run viewer container
viewer_container=$(docker run --privileged --name=quip-viewer  -itd \
	-p $VIEWER_PORT:80 \
	quip_viewer:$VIEWER_VERSION)
echo "Started viewer container: " $viewer_container

exit

## Run viewer container
viewer_container=$(docker run --privileged --name=quip-viewer --net=quip_nw --restart unless-stopped -itd \
	-p $VIEWER_PORT:80 \
        -v $IMAGES_DIR:/data/images \
        -v $STORAGE_FOLDER/configs/security:/var/www/html/config \
        -v $PWD/ViewerDockerContainer/html/camicroscope:/var/www/html/camicroscope \
        -e "GCSFUSEMOUNTS=isb-cgc-open,svs-images,svs-images-mr" \
	quip_viewer:$VIEWER_VERSION)
echo "Started viewer container: " $viewer_container

