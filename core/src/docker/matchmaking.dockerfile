FROM node:18-alpine

WORKDIR /app

ENV \
 NODE_ENV=production \
 PORT=8081

EXPOSE ${PORT}

COPY ./dist/containers/matchmaking.js ./index.js

CMD [ "node", "index.js"]