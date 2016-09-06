-- luacheck: std max+busted

local both_error_messages =
{
  CREATE_BAD_DIRECTORY =
  {
    "mmapfile.create: Error creating 'there_is_no_directory_with_this_name/test': No such file or directory",
    "mmapfile.create: Error creating 'there_is_no_directory_with_this_name/test': The system cannot find the path specified.\r\n"
  },
  OPEN_BAD_FILE =
  {
    "mmapfile.open: Error opening this_file_doesnt_exist: No such file or directory",
    "mmapfile.open: Error opening this_file_doesnt_exist: The system cannot find the file specified.\r\n"
  },
}

local ei = jit.os == "Windows" and 2 or 1
local errors = {}
for k, v in pairs(both_error_messages) do
  errors[k] = v[ei]
end


describe("malloc", function()
  local mmapfile = require"mmapfile"

  test("malloc", function()
    local ptr = assert(mmapfile.malloc(1024, "long"))
    for i = 0, 1023 do
      ptr[i] = i + 1
    end
    for i = 0, 1023 do
      assert.equal(i+1, ptr[i])
    end
    local ptr2 = assert(mmapfile.malloc(1024, "long", ptr))
    for i = 0, 1023 do
      assert.equal(i+1, ptr2[i])
    end

    mmapfile.free(ptr)
    mmapfile.free(ptr2)
  end)

  test("gcmalloc", function()
    do
      local ptr = assert(mmapfile.gcmalloc(1024, "long"))
      for i = 0, 1023 do
        ptr[i] = i + 2
      end
      for i = 0, 1023 do
        assert.equal(i+2, ptr[i])
      end
    end
    collectgarbage()
  end)
end)


describe("mmap", function()
  local mmapfile = require"mmapfile"

  test("mmap", function()
    local ptr = assert(mmapfile.create("test", 1024, "uint32_t"))
    for i = 0, 1023 do
      ptr[i] = i + 3
    end
    mmapfile.close(ptr)
    local size
    ptr, size = mmapfile.open("test", "uint32_t")
    assert.equal(1024, size)
    for i = 0, 1023 do
      assert.equal(i+3, ptr[i])
    end

    local ptr2 = assert(mmapfile.create("test2", 1024, "uint32_t", ptr))
    mmapfile.close(ptr)

    for i = 0, 1023 do
      assert.equal(i+3, ptr2[i])
    end
    mmapfile.close(ptr2)

    ptr2, size = mmapfile.open("test2", "uint32_t")
    assert.equal(1024, size)
    for i = 0, 1023 do
      assert.equal(i+3, ptr2[i])
    end

    mmapfile.close(ptr2)
  end)

  test("can't create file", function()
    assert.has_error(function() mmapfile.create("there_is_no_directory_with_this_name/test", 1024, "uint32_t") end,
        errors.CREATE_BAD_DIRECTORY)
  end)

  test("can't open file", function()
    assert.has_error(function() mmapfile.open("this_file_doesnt_exist", "uint32_t") end,
        errors.OPEN_BAD_FILE)
  end)
end)


describe("mmap-rewrite", function()
  local mmapfile = require"mmapfile"

  test("mmap", function()
    local ptr = assert(mmapfile.create("test7", 1024, "uint32_t"))
    for i = 0, 1023 do
      ptr[i] = i + 7
    end
    mmapfile.close(ptr)
    local size
    ptr, size = mmapfile.open("test7", "uint32_t", "rw")
    assert.equal(1024, size)
    for i = 0, 1023 do
      assert.equal(i+7, ptr[i])
    end
    for i = 0, 1023 do
      ptr[i] = i + 8
    end
    mmapfile.close(ptr)
    ptr, size = mmapfile.open("test7", "uint32_t", "rw")
    assert.equal(1024, size)
    for i = 0, 1023 do
      assert.equal(i+8, ptr[i])
    end
    mmapfile.close(ptr)
  end)

  test("can't create file", function()
    assert.has_error(function() mmapfile.create("there_is_no_directory_with_this_name/test", 1024, "uint32_t") end,
        errors.CREATE_BAD_DIRECTORY)
  end)

  test("can't open file", function()
    assert.has_error(function() mmapfile.open("this_file_doesnt_exist", "uint32_t") end,
        errors.OPEN_BAD_FILE)
  end)
end)



describe("gcmmap", function()
  local mmapfile = require"mmapfile"

  test("mmap", function()
    do
      local ptr = assert(mmapfile.gccreate("test3", 1024, "uint32_t"))
      for i = 0, 1023 do
        ptr[i] = i + 4
      end
    end

    collectgarbage()

    do
      local ptr, size = mmapfile.gcopen("test3", "uint32_t")
      assert.equal(1024, size)
      for i = 0, 1023 do
        assert.equal(i+4, ptr[i])
      end
    end
    collectgarbage()
  end)
end)
