#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
    echo "SNYK_TOKEN not found as environment variable. Please set in workflow before continuing."
    exit 1
fi

snyk auth ${SNYK_TOKEN}

req_file=${INPUT_PACKAGEFILE}

if [ -n "${INPUT_USEOLDPIP}" ]; then
    echo "using older pinned pip 20.2.4"
    python -m pip install  --upgrade pip==20.2.4         #Downgrade pip to below 20.3 which introduces incompatible dependency resolver 
fi

if [ -n "${INPUT_LOCALPACKAGES}" ]; then
    echo "Local package input detected"

    localpackages_str=$(echo $INPUT_LOCALPACKAGES |  tr -d "[] \t\n\r"  ) #Remove [] and whitespace from array string
    
    if [ -n "${localpackages_str}" ]; then
        echo "Local package array not empty, attempt install"
        IFS="," read -a local_packages <<< $localpackages_str #Convert str to array

        for local_package in ${local_packages[@]}
            do 
            echo "Installing local package $local_package"
            pip install -e $local_package
            done

        exlude_pkg_pattern=$(echo $localpackages_str | sed 's/,/\\|/g') #Construct grep exclusion pattern
        echo "filtering using exclusion pattern: ${exlude_pkg_pattern}"

        req_file="requirements-filtered.txt"
        grep -iv "${exlude_pkg_pattern}" ${INPUT_PACKAGEFILE} > ${req_file}
    fi
fi

pip install -r ${req_file}

if [ -n "${INPUT_IGNORE}" ]; then
    echo "${INPUT_IGNORE}" | jq -r '.[]' | while read i; do
        echo "Ignoring https://snyk.io/vuln/${i}"
        snyk ignore --id=${i} --reason="Ignored by workflow" --expiry="$(date -d '+1 hour' --iso-8601=minutes)"
    done
fi

echo "snyk test --file=${req_file} --package-manager=pip ${INPUT_OPTIONS} $*"
OUTPUT=$(snyk test --file=${req_file} --package-manager=pip ${INPUT_OPTIONS} $*)

echo "snyk dependency tree:"
snyk test --file=${req_file}  --package-manager=pip ${INPUT_OPTIONS} --print-deps
CODE=$?

if [ "${CODE}" -ne "0" ]; then
    echo
    snyk test --file=${req_file} --package-manager=pip ${INPUT_OPTIONS} --json $* | snyk-to-html -o results.html
    echo ::set-output name=results::results.html
fi

exit ${CODE}
