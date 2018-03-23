CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -pedantic -g
LDFLAGS =
LDLIBS =

prog = prog
objs = $(patsubst %.c,%.o,$(wildcard *.c))

build: $(prog)

$(prog): $(objs)
	$(CC) -o $@ $(LDFLAGS) $(LDLIBS) $^

clean:
	$(RM) $(objs) $(prog)

.PHONY: build clean
