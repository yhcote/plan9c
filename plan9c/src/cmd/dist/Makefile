CFLAGS=-O2 -Wall -Werror -I. '-DPLAN9C_FINAL="${PLAN9C}"'

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

PROG=dist

.c.o:
	@echo " CC $<"
	@${CC} ${CFLAGS} -c $<

all: $(OBJS) ${PROG}

${PROG}:
	@echo " LINK $@"
	@${CC} -static -o dist ${OBJS}

clean:
	@rm -f ${OBJS} ${PROG}
