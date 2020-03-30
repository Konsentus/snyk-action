#!/bin/bash

if [ -n "${INPUT_IGNORE}" ]; then
    echo "${INPUT_IGNORE}" | jq -r '.[]' | while read i; do
        snyk ignore --id=${i} --reason="Ignored by workflow" --expiry="$(date -d '+1 hour' --iso-8601=minutes)"
    done
fi

pip install -r ${INPUT_PACKAGEFILE}
OUTPUT=$(snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip $*)
CODE=$?

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
