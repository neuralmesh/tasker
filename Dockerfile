FROM node:alpine
WORKDIR /app
ENV CONTAINER_PORT=4000
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE $CONTAINER_PORT
CMD ["node", "index.js"]

