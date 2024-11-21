#!/bin/sh
#
# Usage: build-musl.sh PREFIX

set -ex

PREFIX=$1

export CC=$PREFIX/bin/clang
export CFLAGS="-resource-dir $PREFIX/sysroot/lib"
cd musl
make clean
./configure --prefix=$PREFIX/sysroot --syslibdir=$PREFIX/sysroot/lib
make
make install

# Make the linker symlink relative
rm $PREFIX/sysroot/lib/ld-musl-$ARCH.so.1
ln -s libc.so $PREFIX/sysroot/lib/ld-musl-$ARCH.so.1
