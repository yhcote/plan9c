#!/bin/sh -

set -e

export GOROOT=`git rev-parse --show-toplevel`/plan9c

make -C src/cmd/dist clean
make -C src/cmd/dist all

src/cmd/dist/dist clean -v
src/cmd/dist/dist bootstrap -v
