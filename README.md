First make sure `ccache` is installed, it will make your build *much* faster,
since the build requires compiling LLVM twice (the second time is much faster
thanks to `ccache`).

Download the sources

```
./download.sh
```

Build LFI toolchain

```
./build-lfi.sh $PWD/aarch64-lfi-clang aarch64
```

Build native toolchain (for comparison)

```
./build-native.sh $PWD/aarch64-native-clang aarch64
```

Build LFI toolchain with only sandboxing for stores:

```
LFIFLAGS="--sandbox=stores "./build-lfi.sh $PWD/aarch64-lfi-stores-clang aarch64
```
