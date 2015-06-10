CFLAGS=-O2 -Wall -Werror -I. '-DGOROOT_FINAL="${GOROOT}"'

OBJS=	arm.o \
	buf.o \
	build.o \
	buildgc.o \
	buildgo.o \
	buildruntime.o \
	main.o \
	plan9.o \
	unix.o \
	windows.o

all: $(OBJS)
	${CC} -static -o dist ${OBJS}

clean:
	rm -f ${OBJS} dist
