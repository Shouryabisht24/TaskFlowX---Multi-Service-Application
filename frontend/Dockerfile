FROM node:18-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install

RUN npm install tailwindcss postcss autoprefixer --save-dev

RUN npx tailwindcss init -p

COPY . .

RUN npm run build

FROM nginx:stable-alpine

WORKDIR /app

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]