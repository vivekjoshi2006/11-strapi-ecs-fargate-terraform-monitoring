FROM node:18-alpine
WORKDIR /opt/app

RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev
COPY package*.json ./

RUN npm install
COPY . .

RUN npm run build

EXPOSE 1337
CMD ["npm", "run", "start"]