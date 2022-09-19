FROM node:18-alpine3.16 as build

WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY . /app
RUN yarn run build

FROM nginx:1.18-alpine

COPY --from=build /app/.nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*
COPY --from=build /app/build /frontend/build

#COPY .nginx/nginx.conf /etc/nginx/nginx.conf
#COPY --from=build-step /build/build /frontend/build