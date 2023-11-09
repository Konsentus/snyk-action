FROM snyk/snyk:python-3.10

RUN python -m pip install  --upgrade pip

ADD entrypoint.sh /entrypoint.sh

RUN apt-get update

RUN apt-get install -y nodejs npm jq

RUN npm install snyk-to-html -g

ENTRYPOINT ["/entrypoint.sh"]
