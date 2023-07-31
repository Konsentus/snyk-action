FROM snyk/snyk:node

ADD entrypoint.sh /entrypoint.sh

RUN apk add jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
