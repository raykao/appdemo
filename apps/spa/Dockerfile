FROM node:latest as builder

WORKDIR /app/build/

COPY code/ .

RUN ["npm", "install"]

RUN ["npm", "run", "build"]

FROM nginx:1.15.1-alpine

WORKDIR /app/dist/

COPY --from=builder /app/build/dist/ .

COPY *.conf /etc/nginx/conf.d/