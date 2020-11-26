#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

snyk auth ${SNYK_TOKEN}

localpackages_str=$(echo $INPUT_LOCALPACKAGES |  tr -d [])

IFS="," read -a local_packages <<< $localpackages_str

for local_package in ${local_packages[@]}
    do 
        echo "Installing local package $local_package"
        pip install -e $local_package
    done

exlude_pkg_pattern=$(echo $localpackages_str | tr , \|)  #Construct grep exclusion pattern

grep -iv "${exlude_pkg_pattern}" ${INPUT_PACKAGEFILE} > requirements-filtered.txt
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

exit ${CODE}
