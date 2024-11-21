#!/bin/sh
#
# Usage: build-musl.sh PREFIX

set -ex

PREFIX=$1

export CC=$PREFIX/bin/clang
cd musl
make clean
./configure --prefix=$PREFIX/sysroot --syslibdir=$PREFIX/sysroot/lib
make
make install

# Make the linker symlink relative
rm $PREFIX/sysroot/lib/ld-musl-$MARCH.so.1
ln -sf libc.so $PREFIX/sysroot/lib/ld-musl-$MARCH.so.1
