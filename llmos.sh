#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <git-repo-url>"
    exit 1
fi

REPO_URL=$1

IMAGE_NAME="llmos"
PORT_EXTERN=4000
PORT_INTERN=4000

docker build --build-arg REPO_URL=$REPO_URL -t $IMAGE_NAME .

CONTAINER_USING_PORT=$(docker ps --filter "publish=$PORT_EXTERN" -q)
if [ ! -z "$CONTAINER_USING_PORT" ]; then
    docker stop $CONTAINER_USING_PORT
    docker rm $CONTAINER_USING_PORT
fi

CONTAINER_ID=$(docker run -d -p $PORT_EXTERN:$PORT_INTERN $IMAGE_NAME)

while [ "$(docker inspect --format='{{.State.Running}}' $CONTAINER_ID)" != "true" ]; do
    sleep 1
done

docker exec -it $CONTAINER_ID /bin/sh

