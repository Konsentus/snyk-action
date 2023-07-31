FROM snyk/snyk:node

ADD entrypoint.sh /entrypoint.sh

RUN apt-get -y install jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
