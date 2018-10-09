package = 'lrexrepl'

version = 'scm-0'

source = {
  url = "https://github.com/osch/lrexrepl/archive/master.zip",
  dir = "lrexrepl-master",
}

description = {
    summary = 'Commandline tool: Search and replace in Files',
    detailed = [[
    ]],
    license = 'MIT/X11',
    homepage = "https://github.com/osch/lrexrepl",
}

dependencies = {
    "lrexlib-pcre",
    "luafilesystem"
}

build = {
    type = 'none',
    install = {
        bin = {'lrexrepl' }
    }
}
