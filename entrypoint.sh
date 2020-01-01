#!/bin/bash
printenv
pip install -r ${INPUT_PACKAGE_FILE}
OUTPUT=$(snyk test --file=${INPUT_PACKAGE_FILE} --package-manager=pip $*)
CODE=$?

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    snyk test --file=${INPUT_PACKAGE_FILE} --package-manager=pip --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
