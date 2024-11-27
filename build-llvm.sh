#!/bin/sh

# Usage: build-llvm.sh PREFIX

set -x
set -e

PREFIX=$1

DEFINE_FLAGS="-DLFI_DEFAULT_FLAGS='\"$LFIFLAGS\"'"

mkdir -p $PREFIX/sysroot/usr/lib
mkdir -p $PREFIX/sysroot/lib
mkdir -p $PREFIX/sysroot/usr/include

# Include this if you want LLVMgold.so
# -DLLVM_BINUTILS_INCDIR=/usr/include \

mkdir -p build-llvm
cd build-llvm
cmake -G Ninja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64;WebAssembly" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLLVM_BUILD_DOCS=OFF \
    -DCMAKE_C_FLAGS="$DEFINE_FLAGS" \
    -DCMAKE_CXX_FLAGS="$DEFINE_FLAGS" \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
ninja
cd ..

rm -rf build-llvm-$ARCH-base
mv build-llvm build-llvm-$ARCH-base

# For some reason we have to build LLVM twice -- once without default options,
# used to then compile compiler-rt, and one with the default options we want.
# Luckily ccache will mostly make this efficient.
mkdir build-llvm
cd build-llvm
cmake -G Ninja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64;WebAssembly" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$ARCH-linux-musl" \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
    -DCLANG_DEFAULT_RTLIB="compiler-rt" \
    -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
    -DCLANG_DEFAULT_UNWINDLIB="libunwind" \
    -DCLANG_DEFAULT_LINKER="lld" \
    -DCLANG_DEFAULT_OBJCOPY="llvm-objcopy" \
    -DCMAKE_C_FLAGS="$DEFINE_FLAGS" \
    -DCMAKE_CXX_FLAGS="$DEFINE_FLAGS" \
    -DDEFAULT_SYSROOT=../sysroot
ninja
ninja install/strip
cd ..

mv $PREFIX/bin/lld $PREFIX/bin/lld.orig
./lld.gen > $PREFIX/bin/lld
chmod +x $PREFIX/bin/lld

rm -rf build-llvm-$ARCH
mv build-llvm build-llvm-$ARCH

mkdir -p $PREFIX/lfi-bin
cd $PREFIX/lfi-bin
ln -sf ../bin/clang $ARCH-linux-musl-clang
ln -sf ../bin/clang++ $ARCH-linux-musl-clang++
