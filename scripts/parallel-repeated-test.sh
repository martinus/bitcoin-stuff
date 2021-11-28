#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <bitcoin_test-binary-path>"
    echo "e.g: $0 ~/git/bitcoin/src/test/test_bitcoin | parallel --joblog out.log"
    exit 1
fi

APP=$1
DO_RUN=0

IFS=$'\n\r'
TEST_SUITE=""
for LINE in $(${APP} --list_content 2>&1); do
    STRIPPED_LINE=$(sed 's/^\s*\(.*\)\*/\1/' <<< $LINE)
    if [[ $LINE =~ ^[[:space:]] ]]
    then
        echo "${APP} -t \"${TEST_SUITE}/${STRIPPED_LINE}\""

        if [[ "${DO_RUN}" == "1" ]]
        then
            parallel --halt now,fail=1 "${APP} -t \"${TEST_SUITE}/${STRIPPED_LINE}\"" -- ::: {1..100}
        fi

        # use this to skip past a certain test
        if [[ "${TEST_SUITE}/${STRIPPED_LINE}" == "streams_tests/streams_buffered_file_rand" ]]
        then
            DO_RUN="1"
        fi

    else
        TEST_SUITE=${STRIPPED_LINE}
    fi
done

# bad:
# streams_tests/streams_buffered_file_rand