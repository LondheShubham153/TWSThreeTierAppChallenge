FROM node:14-alpine

WORKDIR /app/

COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

COPY . .

CMD [ "npm","start" ]


