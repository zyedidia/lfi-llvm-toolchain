#!/bin/sh

# Usage: build-llvm.sh PREFIX

set -x
set -e

PREFIX=$1

mkdir -p $PREFIX/sysroot/lib
mkdir -p $PREFIX/sysroot/include

mkdir -p build-llvm-$ARCH-base
cd build-llvm-$ARCH-base

cmake -G Ninja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DLLVM_BINUTILS_INCDIR=/usr/include \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
ninja
cd ..

# For some reason we have to build LLVM twice -- once without default options,
# used to then compile compiler-rt, and one with the default options we want.
mkdir -p build-llvm-$ARCH
cd build-llvm-$ARCH
cmake -G Ninja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DLLVM_BINUTILS_INCDIR=/usr/include \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
    -DCLANG_DEFAULT_RTLIB="compiler-rt" \
    -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
    -DCLANG_DEFAULT_UNWINDLIB="libunwind" \
    -DCLANG_DEFAULT_LINKER="lld" \
    -DCLANG_DEFAULT_OBJCOPY="llvm-objcopy" \
    -DDEFAULT_SYSROOT=../sysroot
ninja
ninja install

mkdir -p $PREFIX/lfi-bin
cd $PREFIX/lfi-bin
ln -sf ../bin/clang $ARCH-linux-musl-clang
ln -sf ../bin/clang++ $ARCH-linux-musl-clang++
