#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

snyk auth ${SNYK_TOKEN}

if [ -n "${INPUT_SSHKEY}" ]; then
        mkdir ~/.ssh && chmod 700 ~/.ssh
        echo "${INPUT_SSHKEY}" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
        eval $(ssh-agent)
        ssh-add ~/.ssh/id_rsa
fi

# pip install -r ${INPUT_PACKAGEFILE}

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
