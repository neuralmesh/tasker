#!/bin/bash

IMAGE_NAME="llmos"
HOST_PORT=4000
CONTAINER_PORT=4000

docker build -t $IMAGE_NAME .
CONTAINER_ID=$(docker run -d -p $HOST_PORT:$CONTAINER_PORT $IMAGE_NAME)

while [ "$(docker inspect --format='{{.State.Running}}' $CONTAINER_ID)" != "true" ]; do
    sleep 1
done

docker exec -it $CONTAINER_ID /bin/sh

