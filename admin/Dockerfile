FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3001
EXPOSE 3001
CMD ["npm", "run", "dev"]
