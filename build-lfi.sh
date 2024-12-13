#!/bin/sh
#
# Usage: build-lfi.sh PREFIX ARCH (aarch64 or x86_64)

set -ex

PREFIX=$1

export MARCH=$2
export ARCH=$2-lfi

./build-llvm.sh $PREFIX
./build-compiler-rt.sh $PREFIX
./build-musl.sh $PREFIX
./build-libcxx.sh $PREFIX

cp $ARCH-linux-musl.cfg $PREFIX/bin

cp $(which lfi-leg) $PREFIX/lfi-bin
cp $(which lfi-postlink) $PREFIX/lfi-bin
cp $(which lfi-verify) $PREFIX/lfi-bin

if [ `uname -m` = "$MARCH" ];
then
    cp $(which lfi-run) $PREFIX/lfi-bin
fi
