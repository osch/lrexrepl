# lrexrepl 
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![Install](https://img.shields.io/badge/Install-LuaRocks-brightgreen.svg)](https://luarocks.org/modules/osch/lrexrepl)

<!-- ---------------------------------------------------------------------------------------- -->

Commandline tool for Search & Replace in multiple files using Regular Expressions and
Lua scripting language.

This package is also available via LuaRocks, see https://luarocks.org/modules/osch/lrexrepl.

See below for full [documentation](#documentation) .

<!-- ---------------------------------------------------------------------------------------- -->

#### Requirements

   * [lrexlib-pcre]
   * [luafilesystem]

[lrexlib-pcre]:  https://luarocks.org/modules/rrt/lrexlib-pcre
[luafilesystem]: https://luarocks.org/modules/hisham/luafilesystem

<!-- ---------------------------------------------------------------------------------------- -->

## Examples

Remove tabs and spaces at end of lines in all files and subdirectories of the current 
directory:

```bash
lrexrepl  -p '[ \t]*$' -r '' -R .
```

Replace all `Hello ...` with `Hello ...!` in the given files:

```bash
lrexrepl  -p '(Hello +\w+)' -r '%1!' file1 file2
```

Add 100 to all numbers in the given files:

```bash
lrexrepl  -p '\d+' -l 'tonumber(m[0])+100' file1 file2
```

Count the number of lines in all files and subdirectories of the current 
directory:

```bash
lrexrepl  -p '^.*$' -b 'c=0' -l 'c=c+1' -e 'printf("count=%d\n",c)' -R .
```

Count the number of newline characters in all files and subdirectories of the current 
directory:

```bash
lrexrepl  -p '\n' -b 'c=0' -l 'c=c+1' -e 'printf("count=%d\n",c)' -R .
```

<!-- ---------------------------------------------------------------------------------------- -->

## Documentation

   * [Invocation](#invocation)
   * [Extensions](#extensions)

<!-- ---------------------------------------------------------------------------------------- -->

### Invocation

```
USAGE:
    lrexrepl [OPTIONS] -p <pat> (-r|-l) <repl> [--] [<file1> ...]

    Searches all given files and replaces all pattern matches by using a
    replace pattern or invoking a given lua script. 

    Options and parameters can appear in any order in the argument list before 
    the first '--'. Every argument after '--' is considered as file name.
    
    If '--' is not specified and no files are given on the commandline, 
    input file names are read line by line from stdin.

PARAMETERS:
    -p <pat>  - search pattern: is a regular expression pattern in PCRE
                syntax.

    -r <repl> - replace pattern: may contain placholder %0 for referencing the
                matched string, %n for the n-th matched group, n = 1...9.

    -l <repl> - lua script called for each match: The script may return 
                the substituted string, or nil if no substitution should be 
                performed for this match. 
                The following variables are given: 'm' contains a table with 
                all subpatterns m[0], m[1], ... (named subpatterns are also 
                supported), variable 'f' contains current file name,
                variable 'startPos' contains start position of the match, 
                variable 'endPos' contains end position of the match.
OPTIONS:
    Single letter options without arguments can be combined, e.g. -Ri is 
    equivalent to -R -i.
    
    -i        - ignore case

    -M        - disable multi line matching, i.e. '^' matches begin of file and
                '$' end of file. Without this option '^' matches begin of line 
                and '$' end of line.

    -s        - dot matches all, i.e. also newlines.
    
    -R        - recurse directories (ignores hidden files, i.e. file names 
                starting with a dot character)

    -b <lua>  - lua script to be called at begin of processing
                before any file is processed.

    -e <lua>  - lua script to be called at the end of processing
                after all files have been processed.
    
    -f <lua>  - lua script to be called for each file before the
                file is being processed.

    -a <lua>  - lua script to be called for each file after the
                file has been processed.
    
    -v        - print verbose output
    -d        - print debug output
    
    -h, --help  print usage
    --version   print version
```

<!-- ---------------------------------------------------------------------------------------- -->

### Extensions

All scripts given as commandline parameter (using option `-l`, `-b`, `-e`, `-f`, `-a`)  can invoke
user supplied functions or use packages without the need for invoking `require`. For this the 
package has to be supplied as subpackage of `lrexrepl-extension`. 

#### Example

Take for example the following Lua file `lrexrepl-extension/foo.lua` for defining a extension
function `foo()`:

```lua
return function(x)
    return tonumber(x) + 100
end
```

Place this file somewhere in the Lua path such it could be required 
with `require("lrexrepl-extension.foo")`.

Then you may simply invoke `foo()` in a lrexrepl command parameter script, e.g. use the following 
commandline to add 100 to all numbers in the given files:

```bash
lrexrepl  -p '\d+' -l 'foo(m[0])' file1 file2
```

User supplied extensions `lrexrepl-extension/?.lua` have precedence over Lua standard globals
or over functions preloaded by lrexrepl. The following functions are preloaded by lrexrepl:

   * `printf()` = print(string.format(...))
   * `format()` = string.format(...)
   * `upper()`  = string.upper(...)
   * `lower()`  = string.lower(...)
   * `capitalize()`  makes first character of argument uppercase
   * `uncapitalize()` makes first character of argument lowercase
   

End of document.

<!-- ---------------------------------------------------------------------------------------- -->
