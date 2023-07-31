FROM snyk/snyk:node

ADD entrypoint.sh /entrypoint.sh

RUN pacman -Syu jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
