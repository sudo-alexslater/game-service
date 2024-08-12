FROM --platform=linux/amd64 node:lts-alpine
WORKDIR /app

ENV \
 NODE_ENV=production \
 PORT=8081

EXPOSE ${PORT}

# copy dist to root
COPY dist .

CMD [ "node", "index.js"]