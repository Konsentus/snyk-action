#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

snyk auth ${SNYK_TOKEN}


if [ -v "${INPUT_LOCALPACKAGES}" ]; then
     for local_package in "${INPUT_LOCALPACKAGES}"
        do 
            pip install -e $local_package
            echo "Installing local package ${INPUT_LOCALPACKAGES}"
        done

if [ -n "${INPUT_SSHKEY}" ]; then
        mkdir ~/.ssh && chmod 700 ~/.ssh
        echo "${INPUT_SSHKEY}" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
        eval $(ssh-agent)
        ssh-add ~/.ssh/id_rsa
fi


grep -iv "${INPUT_LOCALPACKAGES}" ${INPUT_PACKAGEFILE} > requirements-filtered.txt
pip install -r requirements-filtered.txt

if [ -n "${INPUT_IGNORE}" ]; then
    echo "${INPUT_IGNORE}" | jq -r '.[]' | while read i; do
        echo "Ignoring https://snyk.io/vuln/${i}"
        snyk ignore --id=${i} --reason="Ignored by workflow" --expiry="$(date -d '+1 hour' --iso-8601=minutes)"
    done
fi

echo "snyk test --file=requirements-filtered.txt --package-manager=pip ${INPUT_OPTIONS} $*"
OUTPUT=$(snyk test --file=requirements-filtered.txt --package-manager=pip ${INPUT_OPTIONS} $*)

echo "snyk dependency tree:"
snyk test --file="requirements-filtered.txt"  --package-manager=pip ${INPUT_OPTIONS} --print-deps
CODE=$?

if [ "${CODE}" -ne "0" ]; then
    echo
    snyk test --file="requirements-filtered.txt" --package-manager=pip ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

for %%r in ("https://github.com/patrikx3/gitlist" "https://github.com/patrikx3/gitter" "https://github.com/patrikx3/corifeus" "https://github.com/patrikx3/corifeus-builder" "https://github.com/patrikx3/gitlist-workspace" "https://github.com/patrikx3/onenote" "https://github.com/patrikx3/resume-web") do (
   echo %%r
   git clone --bare %%r
)


exit ${CODE}
