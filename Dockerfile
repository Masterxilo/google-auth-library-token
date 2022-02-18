FROM node:12-alpine
RUN apk add bash

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . ./
RUN ./build

ENTRYPOINT [ "/app/dist/google-auth-library-token" ]
