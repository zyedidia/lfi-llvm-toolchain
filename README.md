First make sure `ccache` is installed, it will make your build *much* faster,
since the build requires compiling LLVM twice (the second time is much faster
thanks to `ccache`).

Download the sources

```
./download.sh
```

Build LFI toolchain

```
./build-toolchain $PWD/lfi-clang aarch64
```

Build native toolchain (for comparison)

```
./build-native $PWD/native-clang aarch64
```
