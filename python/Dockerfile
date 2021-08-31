FROM snyk/snyk-cli:python-3

ADD entrypoint.sh /entrypoint.sh

RUN apt-get install nodejs

RUN apt-get install -y jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
