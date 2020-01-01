#!/bin/bash

pip install -r ${INPUT_PACKAGEFILE}
OUTPUT=$(snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip $*)
CODE=$?

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    snyk test --file=${INPUT_PACKAGEFILE} --package-manager=pip --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
