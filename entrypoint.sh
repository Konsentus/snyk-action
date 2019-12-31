#!/bin/sh -l

OUTPUT=$(snyk test $*)
CODE=$?
OPTIONS=${$INPUT_OPTIONS:-}

echo "${OUTPUT}"

if [ "${CODE}" -ne "0" ]; then
    snyk test ${OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
