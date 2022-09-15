FROM node:18-alpine3.16 as build-step

WORKDIR /app

# Setup dependencies 
COPY package*.json .
RUN yarn install

COPY . .

RUN yarn run build

FROM nginx:1.18-alpine as serve-step
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build-step /app/build /frontend/build