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

io.stderr:write("Test passed\n")