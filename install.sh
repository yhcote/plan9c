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
INSTALLDIR=/usr/local/plan9c

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

CC=`musl-gcc -v >/dev/null 2>&1 && echo "musl-gcc" || echo "cc"`
if [ $CC = "cc" ]; then
	echo "***"
	echo "*** WARNING: plan9c builds smaller static binaries with musl"
	echo "***          libc installed"
	echo "***"
fi

echo -n "generate release (r) or debug (d) Makefile.p9c [R/d]? "
read ans
if [ "X$ans" = "Xr" -o "X$ans" = "X" ]; then
	RELFLAGS="-Os"
else
	RELFLAGS="-Og -ggdb"
fi

echo -n "keep local (l) or install system wide (s) in /usr/local/plan0c [L/s]? "
read ans
if [ "X$ans" = "Xs" ]; then
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

CPPFLAGS=	-I ${INSTALLDIR}/include

LDFLAGS=	-static -L ${INSTALLDIR}/lib -lbio -l9
EOF
else
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
fi

if [ "X$ans" = "Xs" ]; then
	echo "===> installing plan9c into $INSTALLDIR ..."
	install -d -o root -g bin -m 755 $INSTALLDIR
	install -d -o root -g bin -m 755 $INSTALLDIR/lib
	install -m 444 ${PLAN9C}/lib/lib9.a $INSTALLDIR/lib
	install -m 444 ${PLAN9C}/lib/libbio.a $INSTALLDIR/lib
	install -m 444 ${PLAN9C}/lib/libcc.a $INSTALLDIR/lib
	install -m 444 ${PLAN9C}/lib/libgc.a $INSTALLDIR/lib
	install -m 444 ${PLAN9C}/lib/liblink.a $INSTALLDIR/lib
	install -d -o root -g bin -m 755 $INSTALLDIR/include
	install -d -o root -g bin -m 755 $INSTALLDIR/include/plan9
	install -d -o root -g bin -m 755 $INSTALLDIR/include/plan9/386
	install -d -o root -g bin -m 755 $INSTALLDIR/include/plan9/amd64
	install -d -o root -g bin -m 755 $INSTALLDIR/include/plan9/arm
	install -m 444 ${PLAN9C}/include/ar.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/bio.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/fmt.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/libc.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/link.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/u.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/src/lib9/utf/utf.h $INSTALLDIR/include
	install -m 444 ${PLAN9C}/include/plan9/bio.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/errno.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/fmt.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/libc.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/link.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/stdarg.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/utf.h $INSTALLDIR/include/plan9
	install -m 444 ${PLAN9C}/include/plan9/386/u.h $INSTALLDIR/include/plan9/386/u.h
	install -m 444 ${PLAN9C}/include/plan9/amd64/u.h $INSTALLDIR/include/plan9/amd64/u.h
	install -m 444 ${PLAN9C}/include/plan9/arm/u.h $INSTALLDIR/include/plan9/arm/u.h
	install -d -o root -g bin -m 755 $INSTALLDIR/share
	install -m 444 ${TOP}/README $INSTALLDIR/share
	install -m 444 ${TOP}/Makefile.p9c $INSTALLDIR/share
fi

echo ""; echo "Success ! Makefile.p9c ready for use !"
