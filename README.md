# Lua-mmapfile - A simple interface to mmap

## 1. What?

mmapfile uses `mmap` to provide a way of quickly storing and loading data
that's already in some kind of in-memory binary format.

`create` creates a new file and maps new memory to that file.  You can
then write to the memory to write to the file.

`open` opens an existing file and maps its contents to memory, returning
a pointer to the memory and the length of the file.

`close` syncs memory to the file, closes the file, and deletes the
mapping between the memory and the file.

The "gc" variants of `create` and `open` (`gccreate` and `gcopen`) set
up a garbage collection callback for the pointer so that the file is
correctly closed when the pointer is no longer referenced.  Not
appropriate if you might be storing the pointer in C, referencing it from
unmanaged memory, or casting it to another type!

All memory is mapped above 4G to try to keep away from the memory space
LuaJIT uses.


## 2. How?

    local ffi = require"ffi"

    ffi.cdef"struct test { int a; double b; };"

    local mmapfile = require"mmapfile"

    local ptr1 = mmapfile.gccreate("mmapfile-test", 1, "struct test")
    ptr1.a = 1
    ptr1.b = 1.5
    ptr1 = nil
    collectgarbage()

    local ptr2, size = mmapfile.gcopen("mmapfile-test", "struct test")
    assert(size == 1)
    assert(ptr2.a == 1)
    assert(ptr2.b == 1.5)

For more details `make doc` or `ldoc lua --all`.


## 3. Requirements

[LuaJIT](http://luajit.org) and
[ljsyscall](https://github.com/justincormack/ljsyscall)


## 4. Issues

+ Should probably have an option for directly mapping existing memory, but
  I don't know enough about page boundaries.
+ No windows support
