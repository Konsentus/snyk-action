#!/bin/sh -l

echo "snyk test ${INPUT_OPTIONS} $*"
OUTPUT=$(snyk test ${INPUT_OPTIONS} $*)
CODE=$?

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    echo "snyk test ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html"
    snyk test ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
