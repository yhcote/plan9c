#!/bin/sh -

set -e

TOP=`git rev-parse --show-toplevel`
PLAN9C=$TOP/plan9c;	export PLAN9C

# build dist
make -C $PLAN9C/src/cmd/dist all

# use dist and build libs
$PLAN9C/src/cmd/dist/dist clean -v
$PLAN9C/src/cmd/dist/dist bootstrap -v

# remove dist
make -C $PLAN9C/src/cmd/dist clean
