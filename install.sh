#!/bin/sh -
# Copyright (c) 2015, Yannick Cote <yanick@divyan.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# This attemps to build plan9c libs taken from golang 1.4.2 and generate a
# Makefile.p9c for the host.
#
set -e

#
# 1- build plan9 C libaries
#
TOP=`git rev-parse --show-toplevel`
PLAN9C=$TOP/plan9c;	export PLAN9C

# build dist
echo "===> building go dist tool"
(cd $PLAN9C/src/cmd/dist && make all)

# use dist and build libs
echo "===> building plan9 C libraries"
$PLAN9C/src/cmd/dist/dist clean -v
$PLAN9C/src/cmd/dist/dist bootstrap -v

# remove dist
(cd $PLAN9C/src/cmd/dist && make clean)

#
# 2- generate Makefile.p9c
#
echo "===> generating Makefile.p9c for host"

CC=`musl-gcc 2>/dev/null && echo "musl-gcc" || echo "cc"`
if [ $CC = "cc" ]; then
	echo "*** plan9c builds smaller static binaries with musl libc installed"
fi

echo -n "generate release (r) or debug (d) Makefile.p9c [R/d]? "
read ans
if [ "X$ans" = "Xr" -o "X$ans" = "X" ]; then
	RELFLAGS="-Os"
else
	RELFLAGS="-Og -ggdb"
fi

cat <<EOF > Makefile.p9c
#
# Builds C programs with plan9 C and link them statically with musl libc on
# Linux if available, for a fast clean and compact freestanding executable
# binary.
#
CC=${CC}

CFLAGS=		-Wall -Wstrict-prototypes -Wextra -Wunused -Wno-sign-compare
CFLAGS+=	-Wno-missing-braces -Wno-parentheses -Wno-unknown-pragmas
CFLAGS+=	-Wno-switch -Wno-comment -Wno-missing-field-initializers
CFLAGS+=	-Werror -fno-common

CFLAGS+=	$RELFLAGS -pipe -Wuninitialized -fmessage-length=0

CPPFLAGS=	-I ${PLAN9C}/include

LDFLAGS=	-static -L ${PLAN9C}/lib -lbio -l9
EOF
