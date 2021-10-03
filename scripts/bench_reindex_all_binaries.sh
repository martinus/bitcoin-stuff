#!/bin/sh
set -ex

echo "usage: $0 <bitcoind1> <bitcoind2> <bitcoind3> ..."

DATADIR=/home/martinus/bitcoin/db/

# default: 450
DBCACHE=4000

# block 690000, see https://www.blockchain.com/btc/block/690000
ASSUMEVALID=00000000000000000002a23d6df20eecec15b21d32c75833cce28f113de888b7
ASSUMEVALID=0
STOPATHEIGHT=300000
#STOPATHEIGHT=690000

sudo pyperf system tune

for BITCOIND in $@
do
    echo ${BITCOIND}
    OUTPREFIX=$(basename ${BITCOIND})

    rm -f ${PWD}/${OUTPREFIX}.debug.log
    /usr/bin/time -v ${BITCOIND} -datadir=${DATADIR} -dbcache=${DBCACHE} -assumevalid=${ASSUMEVALID} -reindex-chainstate -printtoconsole=0 -stopatheight=${STOPATHEIGHT} -debuglogfile=${PWD}/${OUTPREFIX}.debug.log >${OUTPREFIX}.time.txt 2>&1
done

sudo pyperf system reset
