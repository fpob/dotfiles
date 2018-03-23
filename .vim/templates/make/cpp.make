CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -pedantic -g
LDFLAGS =
LDLIBS =

prog = prog
objs = $(patsubst %.cc,%.o,$(wildcard *.cc))

build: $(prog)

$(prog): $(objs)
	$(CXX) -o $@ $(LDFLAGS) $(LDLIBS) $^

clean:
	$(RM) $(objs) $(prog)

.PHONY: build clean
