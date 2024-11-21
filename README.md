First make sure `ccache` is installed (trust me, it's worth it).

Download the sources

```
./download.sh
```

Build LFI toolchain

```
./build-toolchain $PWD/lfi-clang-arm64 aarch64
```

Build native toolchain (for comparison)

```
./build-native $PWD/native-clang aarch64
```
