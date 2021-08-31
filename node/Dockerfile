FROM snyk/snyk-cli:npm

ADD entrypoint.sh /entrypoint.sh

RUN apt-get install -y jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
