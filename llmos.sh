#!/bin/bash

# Name of the Docker image
IMAGE_NAME="llmos"

# Create Dockerfile
cat <<EOF > Dockerfile
FROM alpine
RUN apk add --no-cache bash
COPY ./scripts /scripts
WORKDIR /scripts
ENTRYPOINT ["/bin/bash"]
EOF

# Build Docker image
docker build -t $IMAGE_NAME .

# Run Docker container
docker run -it $IMAGE_NAME

