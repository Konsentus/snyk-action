#!/bin/sh

OUTPUT=$(snyk test $*)
CODE=${PIPESTATUS[0]}

echo "${OUTPUT}"

if (( ${CODE} )); then
    snyk test --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi
