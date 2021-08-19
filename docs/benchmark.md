# Run bitcoin with reindex, and automatically stop at a given height.


```sh
rm 
bench /usr/bin/time -v ~/git/bitcoin-martinus/src/bitcoind -datadir=/run/media/martinus/big/bitcoin/db -dbcache=10000 -assumevalid=00000000000000000002a23d6df20eecec15b21d32c75833cce28f113de888b7 -reindex-chainstate -printtoconsole=0 -stopatheight=200000
```
