FROM node:18 AS install
WORKDIR /app
COPY package*.json ./
RUN npm install


FROM node:18 as build
WORKDIR /app
COPY --from=install /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:18
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
EXPOSE 3000
CMD [ "npm", "run", "start:prod" ]