package = "mmapfile"
version = "1-1"
source =
{
  url = "git://github.com/geoffleyland/lua-mmapfile.git",
  branch = "master",
  tag = "v1",
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
    'ljsyscall >= 0.9',
}
build =
{
  type = "builtin",
  modules =
  {
    mmapfile = "lua/mmapfile.lua",
  },
}
