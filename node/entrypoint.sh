#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

snyk auth ${SNYK_TOKEN}

if [ -n "${INPUT_IGNORE}" ]; then
    echo "${INPUT_IGNORE}" | jq -r '.[]' | while read i; do
        echo "Ignoring https://snyk.io/vuln/${i}"
        snyk ignore --id=${i} --reason="Ignored by workflow" --expiry="$(date -d '+1 hour' --iso-8601=minutes)"
    done
fi

echo "snyk test ${INPUT_OPTIONS} $*"
OUTPUT=$(snyk test ${INPUT_OPTIONS} $*)
CODE=$?

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    snyk test ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
