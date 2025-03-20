#!/bin/sh

./build-native.sh $PWD/x86_64-native-clang x86_64

./build-lfi.sh $PWD/x86_64-lfi-clang x86_64

LFIFLAGS="--sandbox=stores" ./build-lfi.sh $PWD/x86_64-lfi-stores-clang x86_64
