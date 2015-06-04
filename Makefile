include Makefile.p9c

PROG=		hello
OBJS=		hello.o

all: ${PROG}

hello: ${OBJS}
	${CC} -o $@ ${OBJS} ${LDFLAGS}

clean:
	rm -f ${OBJS} ${PROG}
