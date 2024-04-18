FROM node:18-alpine AS base
EXPOSE 3000

FROM base AS pruned
WORKDIR /app
COPY package.json package-lock.json ./
RUN apk update && apk add curl
RUN npm install yarn
RUN yarn install --production
RUN curl -sf https://gobinaries.com/tj/node-prune | sh
RUN node-prune
EXPOSE 3000

FROM base as development
WORKDIR /app
COPY ./src ./src
RUN npm install yarn
COPY package.json package-lock.json tsconfig.build.json tsconfig.json .eslintrc.js .prettierrc ./
RUN yarn install
RUN yarn run build
EXPOSE 3000
CMD ["sh", "-c", "yarn run start:dev"]

FROM base AS production
WORKDIR /app
RUN npm install yarn
COPY --from=development /app/dist ./dist
COPY --from=pruned /app/package.json /app/package-lock.json ./
COPY --from=pruned /app/node_modules ./node_modules
EXPOSE 3000
CMD ["sh", "-c", "yarn run start:prod"]