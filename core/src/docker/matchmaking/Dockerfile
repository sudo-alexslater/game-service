FROM node:18-alpine

WORKDIR /app

ENV \
 NODE_ENV=production \
 PORT=8081

EXPOSE ${PORT}

# copy current directory to /app
COPY dist/matchmaking.js ./index.js

CMD [ "node", "index.js"]