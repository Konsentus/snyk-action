FROM snyk/snyk:python-3.9

RUN python -m pip install  --upgrade pip

ADD entrypoint.sh /entrypoint.sh

RUN apt-get install nodejs

RUN apt-get install -y jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
