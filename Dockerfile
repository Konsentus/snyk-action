FROM snyk/snyk-cli:npm

LABEL version="1.0.0"
LABEL repository="https://github.com/konsentus/snyk-action"
LABEL maintainer="Konsentus"

LABEL com.github.actions.name="Snyk Action"
LABEL com.github.actions.description="Check dependencies with Snyk"
LABEL com.github.actions.icon="shield"
LABEL com.github.actions.color="purple"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
