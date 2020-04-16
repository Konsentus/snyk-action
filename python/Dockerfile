FROM snyk/snyk-cli:python-3

ADD entrypoint.sh /entrypoint.sh

RUN apt-get install nodejs
RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
