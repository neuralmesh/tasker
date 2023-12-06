#!/bin/bash

# Usage check and argument assignment
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <git-repo-url> <image-name> <port-mappings>"
    exit 1
fi
REPO_URL=$1
IMAGE_NAME=$2
PORT_MAPPINGS=${@:3}

# Create Dockerfile
cat <<EOF > Dockerfile
FROM node:alpine
RUN apk add --no-cache git

# Adding a variable that changes on every build to ensure the git clone is not cached
ARG CACHEBUST=$(date +%s)
RUN echo "Cache bust: \$CACHEBUST" && git clone $REPO_URL /app

WORKDIR /app
ENTRYPOINT ["./entrypoint.sh"]
EOF

for PORT in $PORT_MAPPINGS; do
    echo "EXPOSE $PORT" >> Dockerfile
done

# Build Docker container
docker build -t $IMAGE_NAME .

# Run Docker container and capture the container ID
CONTAINER_ID=$(docker run -d $(echo $PORT_MAPPINGS | sed 's/ / -p /g' | xargs echo -p) $IMAGE_NAME)

# Output the logs from the container
echo "Fetching logs from the container..."
docker logs $CONTAINER_ID

# Build and run Docker container
docker build -t $IMAGE_NAME .

# Run Docker container and capture the container ID
CONTAINER_ID=$(docker run -d $(echo $PORT_MAPPINGS | sed 's/ / -p /g' | xargs echo -p) $IMAGE_NAME)

# Output the logs from the container
echo "Fetching logs from the container..."
docker logs $CONTAINER_ID

