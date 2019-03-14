APPS = apps/tcp_echo \
       apps/udp_echo \
       apps/router

TEST = test/raw_test \
       test/ethernet_test \
       test/slip_test \
       test/arp_test

OBJS = util.o \
       net.o \
       ethernet.o \
       slip.o \
       arp.o \
       ip_addr.o \
       ip.o \
       icmp.o \
       udp.o \
       tcp.o \
       dhcp.o \
       microps.o

CFLAGS := $(CFLAGS) -g -W -Wall -Wno-unused-parameter -I .

ifeq ($(shell uname),Linux)
	OBJS := $(OBJS) raw_tap.o
	CFLAGS := $(CFLAGS) -lpthread -pthread
endif

ifeq ($(shell uname),Darwin)
	OBJS := $(OBJS) raw_bpf.o
endif

.SUFFIXES:
.SUFFIXES: .c .o

.PHONY: all clean

all: $(APPS) $(TEST)

$(APPS): % : %.o $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(TEST): % : %.o $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(APPS) $(APPS:=.o) $(OBJS) $(TEST) $(TEST:=.o)
