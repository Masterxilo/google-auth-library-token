#FROM node:12-alpine # the compiled binary does not work within alpine.. gives 'path not found'...
#RUN apk add bash
FROM ubuntu
RUN apt-get update
RUN apt-get install -y curl sudo
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash - ; sudo apt-get install -y nodejs

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . ./
RUN ./build
RUN ls -l /app/dist/google-auth-library-token
ENTRYPOINT [ "/app/dist/google-auth-library-token" ]
