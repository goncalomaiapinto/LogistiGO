FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install -g vite && npm install

COPY . .

EXPOSE 5173
