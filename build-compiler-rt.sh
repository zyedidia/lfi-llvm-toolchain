#!/bin/sh

# Usage: build-compiler-rt.sh PREFIX

set -ex

LLVM_MAJOR=19

PREFIX=$1

# compiler-rt
rm -rf build-compiler-rt-$ARCH
mkdir -p build-compiler-rt-$ARCH
cd build-compiler-rt-$ARCH
cmake -G Ninja ../llvm-project/compiler-rt \
    -DCMAKE_C_COMPILER=$PWD/../build-llvm-$ARCH-base/bin/clang \
    -DCMAKE_CXX_COMPILER=$PWD/../build-llvm-$ARCH-base/bin/clang++ \
    -DLLVM_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DCMAKE_C_COMPILER_TARGET="$ARCH-linux-musl" \
    -DCMAKE_ASM_COMPILER_TARGET="$ARCH-linux-musl" \
    -DCOMPILER_RT_BUILD_BUILTINS=ON \
    -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
    -DCOMPILER_RT_BUILD_MEMPROF=OFF \
    -DCOMPILER_RT_BUILD_PROFILE=OFF \
    -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
    -DCOMPILER_RT_BUILD_XRAY=OFF \
    -DCOMPILER_RT_BUILD_ORC=OFF \
    -DCOMPILER_RT_BUILD_CTX_PROFILE=OFF \
    -DCMAKE_C_COMPILER_WORKS=ON \
    -DCMAKE_CXX_COMPILER_WORKS=ON \
    -DCMAKE_INSTALL_PREFIX=$PREFIX/lib/clang/$LLVM_MAJOR
ninja
ninja install
