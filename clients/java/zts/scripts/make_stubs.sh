#!/bin/bash

# If the zts_core dependency has been updated, then this script should be run
# manually to pick up the latest rdl to generate the appropriate client library
# however, we're not going to run this utility during our automated builds since
# builds must be done based on files already checked-in into git

if [ ! -z "${GITHUB_ACTIONS}" ]; then
    echo >&2 "------------------------------------------------------------------------";
    echo >&2 "SOURCE NOTICE";
    echo >&2 "------------------------------------------------------------------------";
    echo >&2 "Automated Build. Skipping source generation...";
    exit 0;
fi

# Note this script is dependent on the rdl utility.
# go install github.com/ardielle/ardielle-tools/rdl@latest

if [ -x "$(command -v go)" ]; then
    go install github.com/ardielle/ardielle-tools/rdl@latest
fi

command -v rdl >/dev/null 2>&1 || {
    echo >&2 "------------------------------------------------------------------------";
    echo >&2 "SOURCE WARNING";
    echo >&2 "------------------------------------------------------------------------";
    echo >&2 "Please install rdl utility: go install github.com/ardielle/ardielle-tools/rdl@latest";
    echo >&2 "Skipping source generation...";
    exit 0;
}

RDL_FILE=../../../core/zts/src/main/rdl/ZTS.rdl

echo "Generate the client library..."
rdl -s generate -o src/main/java -x c=ZTSRDLGenerated athenz-java-client $RDL_FILE
