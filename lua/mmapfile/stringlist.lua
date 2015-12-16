local ffi = require"ffi"
local mmapfile = require"mmapfile"


------------------------------------------------------------------------------

local string_list = {}
string_list.__index = string_list


function string_list:new()
  return setmetatable({ count = 0, size = 0, strings = {}, map = {} }, self)
end


function string_list:add(s)
  if not self.map[s] then
    self.count = self.count + 1
    self.strings[self.count] = s
    self.map[s] = self.size
    self.size = self.size + #s + 1
  end
end


function string_list:write(filename)
  table.sort(self.strings)

  local string_ptr = mmapfile.gccreate(filename, self.size, "char")

  local offset = 0
  for i, s in ipairs(self.strings) do
    self.map[s] = offset
    ffi.copy(string_ptr + offset, s)
    offset = offset + #s + 1
  end

  return string_ptr
end


function string_list:offset(s)
  return self.map[s]
end


------------------------------------------------------------------------------

return string_list

------------------------------------------------------------------------------
