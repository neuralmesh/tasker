FROM node:alpine
RUN apk add --no-cache git
WORKDIR /app
ENV CONTAINER_PORT=4000
ARG REPO_URL
RUN git clone ${REPO_URL} .
RUN npm install
EXPOSE $CONTAINER_PORT
CMD ["node", "index.js"]

