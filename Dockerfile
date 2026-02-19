FROM node:20-alpine AS build
RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev vips-dev
WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install
WORKDIR /opt/app
COPY . .
RUN npm run build

FROM node:20-alpine
RUN apk add --no-cache vips-dev
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV NODE_ENV=production
EXPOSE 1337
CMD ["npm", "run", "start"]