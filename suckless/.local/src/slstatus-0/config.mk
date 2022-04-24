# slstatus version
VERSION = 0

# customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# flags
CPPFLAGS = -I$(X11INC) -D_DEFAULT_SOURCE
CFLAGS   = -std=c11 -pedantic -Wall -Wextra -O3 -mtune=native -flto -fno-math-errno
LDFLAGS  = -L$(X11LIB) -s
# OpenBSD: add -lsndio
# FreeBSD: add -lkvm
LDLIBS   = -lX11 -lsndio

# compiler and linker
CC = cc