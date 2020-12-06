FROM node:12.16.3 as build

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm i && npm cache clean --force

COPY tsconfig*.json ./
COPY ./src ./src
RUN npm run build

FROM node:12.16.3-alpine

WORKDIR /app

COPY package*.json ./
RUN npm i --production

COPY --from=build /usr/src/app/dist ./dist

ENV NODE_ENV=production
ENV PORT=8080

# Bind to the port 
EXPOSE 8080
CMD [ "npm", "run", "start:prod" ] 