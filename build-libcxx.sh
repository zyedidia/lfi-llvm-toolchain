#!/bin/sh
#
# Usage: build-libcxx.sh PREFIX

set -ex

PREFIX=$1

rm -rf $PREFIX/sysroot/include/linux
rm -rf $PREFIX/sysroot/include/asm
rm -rf $PREFIX/sysroot/include/asm-generic

cp -r /usr/include/linux $PREFIX/sysroot/include
cp -r /usr/include/asm $PREFIX/sysroot/include
cp -r /usr/include/asm-generic $PREFIX/sysroot/include

mkdir -p build-libcxx-$ARCH
cd build-libcxx-$ARCH
rm -rf CMakeFiles CMakeCache.txt
cmake -G Ninja ../llvm-project/runtimes \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=$PREFIX/bin/clang \
    -DCMAKE_CXX_COMPILER=$PREFIX/bin/clang \
    -DLIBCXX_HAS_MUSL_LIBC=YES \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX/sysroot \
    -DLIBUNWIND_ENABLE_SHARED=NO \
    -DLIBCXXABI_ENABLE_SHARED=NO \
    -DLIBCXX_ENABLE_SHARED=NO \
    -DLIBCXXABI_LINK_TESTS_WITH_SHARED_LIBCXX=OFF \
    -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF \
    -DLIBCXX_LINK_TESTS_WITH_SHARED_LIBCXXABI=OFF \
    -DLIBCXX_LINK_TESTS_WITH_SHARED_LIBCXX=OFF \
    -DCMAKE_C_COMPILER_WORKS=ON \
    -DCMAKE_CXX_COMPILER_WORKS=ON
ninja unwind cxxabi cxx
ninja install
