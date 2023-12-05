#!/bin/bash

IMAGE_NAME="llmos"
PORT_EXTERN=4000
PORT_INTERN=4000

docker build -t $IMAGE_NAME .

CONTAINER_USING_PORT=$(docker ps --filter "publish=$PORT_EXTERN" -q)
if [ ! -z "$CONTAINER_USING_PORT" ]; then
    echo "Port $PORT_EXTERN is in use by container $CONTAINER_USING_PORT. Stopping and removing it..."
    docker stop $CONTAINER_USING_PORT
    docker rm $CONTAINER_USING_PORT
fi

CONTAINER_ID=$(docker run -d -p $PORT_EXTERN:$PORT_INTERN $IMAGE_NAME)

while [ "$(docker inspect --format='{{.State.Running}}' $CONTAINER_ID)" != "true" ]; do
    sleep 1
done

docker exec -it $CONTAINER_ID /bin/sh

