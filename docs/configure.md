# Sanitizers

```bash
make distclean
./configure CXX=clang++ CC=clang --with-incompatible-bdb --with-sanitizers=address,integer,undefined
make -j14
export BASE_ROOT_DIR=/home/martinus/git/bitcoin
export ASAN_OPTIONS="detect_stack_use_after_return=1:check_initialization_order=1:strict_init_order=1"
export UBSAN_OPTIONS="suppressions=${BASE_ROOT_DIR}/test/sanitizer_suppressions/ubsan:print_stacktrace=1:halt_on_error=1:report_error_type=1"
```

See `developer-notes.md` and `00_setup_env_native_asan.sh`