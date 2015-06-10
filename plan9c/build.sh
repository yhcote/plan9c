#!/bin/sh -

set -e

export GOROOT=`git rev-parse --show-toplevel`/plan9c

# build dist
make -C src/cmd/dist clean
make -C src/cmd/dist all

# use dist and build libs
src/cmd/dist/dist clean -v
src/cmd/dist/dist bootstrap -v
