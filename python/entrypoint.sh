#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

if [ -n "${BOT_SSH_KEY}" ]; then
    mkdir ~/.ssh && chmod 700 ~/.ssh
    echo "${BOT_SSH_KEY}" > ~/.ssh/id_rsa.pub && chmod 600 ~/.ssh/id_rsa.pub
    eval $(ssh-agent)
    ssh-add ~/.ssh/id_rsa.pub
fi

snyk auth ${SNYK_TOKEN}

python -m pip install  --upgrade pip==20.2.4

if [ -n "${INPUT_DOWNLOADDIR}" ]; then
    pip install --find-links=${INPUT_DOWNLOADDIR} -r ${INPUT_PACKAGEFILE}
else
    pip install -r ${INPUT_PACKAGEFILE}
fi

if [ -n "${INPUT_IGNORE}" ]; then
    echo "${INPUT_IGNORE}" | jq -r '.[]' | while read i; do
        echo "Ignoring https://snyk.io/vuln/${i}"
        snyk ignore --id=${i} --reason="Ignored by workflow" --expiry="$(date -d '+1 hour' --iso-8601=minutes)"
    done
fi

echo "snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip ${INPUT_OPTIONS} $*"
OUTPUT=$(snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip ${INPUT_OPTIONS} $*)
CODE=$?

if [ "${CODE}" -ne "0" ]; then
    echo
    snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
