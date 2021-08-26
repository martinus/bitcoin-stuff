#!/bin/sh
set -e

if [ "$#" -ne 3 ]; then
    echo "usage: $0 <bitdoind> <datadir> <outprefix>"
    echo "e.g: $0 ~/git/bitcoin/src/bitcoind /home/martinus/bitcoin/db/ nodeallocator"
    exit 1
fi

BITCOIND=$1
DATADIR=$2
OUTPREFIX=$3

# block 690000, see https://www.blockchain.com/btc/block/690000
ASSUMEVALID=00000000000000000002a23d6df20eecec15b21d32c75833cce28f113de888b7
#STOPATHEIGHT=690000
STOPATHEIGHT=690000

# default: 450
DBCACHE=10000

# source ~/git/venv/bin/activate
sudo pyperf system tune
rm -f ${PWD}/${OUTPREFIX}.debug.log
/usr/bin/time -v ${BITCOIND} -datadir=${DATADIR} -dbcache=${DBCACHE} -assumevalid=${ASSUMEVALID} -reindex-chainstate -printtoconsole=0 -stopatheight=${STOPATHEIGHT} -debuglogfile=${PWD}/${OUTPREFIX}.debug.log >${OUTPREFIX}.time.txt 2>&1
sudo pyperf system reset
