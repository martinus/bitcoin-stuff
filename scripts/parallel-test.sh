#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "usage: $0 <bitcoin_test-binary-path> <suppressions> | parallel --joblog out.log"
    echo "e.g: $0 ~/git/bitcoin/src/test/test_bitcoin ~/git/bitcoin/src/test ~/git/bitcoin/contrib/valgrind.supp | parallel --joblog out.log"
    exit 1
fi

APP=$1
SUP=$2

IFS=$'\n\r'
TEST_SUITE=""
for LINE in $(${APP} --list_content 2>&1); do
    STRIPPED_LINE=$(sed 's/^\s*\(.*\)\*/\1/' <<< $LINE)
    if [[ $LINE =~ ^[[:space:]] ]]
    then
        echo "valgrind --suppressions=${SUP} --leak-check=full --error-exitcode=1 --exit-on-first-error=yes --show-leak-kinds=all --gen-suppressions=all ${APP} -r no -t \"${TEST_SUITE}/${STRIPPED_LINE}\""
    else
        TEST_SUITE=${STRIPPED_LINE}
    fi
done
