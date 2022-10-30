#FROM node:12-alpine # the compiled binary does not work within alpine.. gives 'path not found'...
#RUN apk add bash
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y curl sudo
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - ; sudo apt-get install -y nodejs

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . ./
RUN ./build
RUN ls -l /app/dist/google-auth-library-token
RUN ldd /app/dist/google-auth-library-token
RUN ( /app/dist/google-auth-library-token || true ) 2>&1 | grep -F 'GOOGLE_APPLICATION_CREDENTIALS environment variable is not set!'

ENTRYPOINT [ "/app/dist/google-auth-library-token" ]
