package = "mmapfile"
version = "scm-3"
source =
{
  url = "git://github.com/geoffleyland/lua-mmapfile.git",
  branch = "master",
}
description =
{
  summary = "Simple memory-mapped files",
  homepage = "http://github.com/geoffleyland/lua-mmapfile",
  license = "MIT/X11",
  maintainer = "Geoff Leyland <geoff.leyland@incremental.co.nz>"
}
dependencies =
{
  'lua == 5.1',               -- should be "luajit >= 2.0.0"
  platforms =
  {
    linux = { 'ljsyscall >= 0.9' },
    macosx = { 'ljsyscall >= 0.9' },
  }
}
build =
{
  type = "builtin",
  modules =
  {
    mmapfile = "src-lua/mmapfile.lua",
    ["mmapfile.unix"] = "src-lua/mmapfile/unix.lua",
    ["mmapfile.windows"] = "src-lua/mmapfile/windows.lua",
    ["mmapfile.string_list"] = "src-lua/mmapfile/string_list.lua",
  },
}
