FROM snyk/snyk-cli:npm

RUN npm install snyk-to-html -g

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
