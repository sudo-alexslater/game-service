FROM --platform=linux/amd64 node:lts-alpine
WORKDIR /app

ENV \
 NODE_ENV=production \
 PORT=8081

EXPOSE ${PORT}

# copy current directory to /app
COPY dist/index.js ./index.js

CMD [ "node", "index.js"]