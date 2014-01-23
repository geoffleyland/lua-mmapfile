LUA= $(shell echo `which lua`)
LUA_BINDIR= $(shell echo `dirname $(LUA)`)
LUA_PREFIX= $(shell echo `dirname $(LUA_BINDIR)`)
LUA_VERSION = $(shell echo `lua -v 2>&1 | cut -d " " -f 2 | cut -b 1-3`)
LUA_SHAREDIR=$(LUA_PREFIX)/share/lua/$(LUA_VERSION)

default:
	@echo "Nothing to build.  Try 'make install'."

install:
	cp lua/mmapfile.lua $(LUA_SHAREDIR)

doc: lua/mmapfile.lua lua/config.ld
	ldoc lua --all

test:
	cd lua && luajit test/test.lua