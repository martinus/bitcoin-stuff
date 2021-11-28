Get it here: https://github.com/aras-p/ClangBuildAnalyzer

Checkout & build, e.g. with

```sh
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ..
ninja
```

Configure so `-ftime-trace` is added

```sh
./autogen.sh && ./configure --with-incompatible-bdb --disable-gui-tests CC="clang -ftime-trace" CXX="clang++ -ftime-trace" && make clean
```

Start recording, build everything, stop recording

```sh
~/git/external/ClangBuildAnalyzer/bin/ClangBuildAnalyzer --start .
export CCACHE_DISABLE=1
make -j14 check
~/git/external/ClangBuildAnalyzer/bin/ClangBuildAnalyzer --stop . trace
```

This creates lots of json files.
