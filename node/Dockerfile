FROM snyk/snyk-cli:node

ADD entrypoint.sh /entrypoint.sh

RUN apt-get install -y jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
