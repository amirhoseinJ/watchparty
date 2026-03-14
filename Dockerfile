FROM node:24-alpine AS builder

WORKDIR /usr/src

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build


FROM node:24-alpine AS runner

WORKDIR /usr/src

COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts

COPY --from=builder /usr/src/build ./build
COPY --from=builder /usr/src/server ./server
COPY --from=builder /usr/src/public ./public

EXPOSE 8080

CMD ["npm", "start"]
