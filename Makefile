include Makefile.p9c

PROG=		hello
OBJS=		hello.o

all: $(OBJS) ${PROG}

hello:
	${CC} -o $@ ${OBJS} ${LDFLAGS}

clean:
	rm -f ${OBJS} ${PROG}
