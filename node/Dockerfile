FROM snyk/snyk-cli:npm

ADD entrypoint.sh /entrypoint.sh

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
