#!/usr/bin/env python
import re
import os, sys

# Matches Verilog module and primitive declarations, returning one
# group: the module's identifier. This is broken on escaped
# identifiers, but otherwise it follows the language spec. More or
# less. It's still dirty as hell.
module_name_regexp = re.compile(r'\s(module|primitive|macromodule)\s+([a-zA-Z_][a-zA-Z_$0-9]*)', re.MULTILINE)

def getModuleNames(string):
    '''Return a list of all module and primitive names in string,
    which is assumed to be the text of a Verilog file.'''
    return [m[1] for m in module_name_regexp.findall(string)]

def mangleName(identifier):
    '''Take a Verilog identifier and return a mangled version that is
    guaranteed not to conflict with the Quartus built-in
    library. Probably. Just adds a couple underscores, really.'''
    return '__%s'%identifier

def openOrStd(filename, mode='r'):
    '''Like open(), but defaults to stdin or stdout if filename is -,
    and only supports r and w modes.'''
    if filename == '-' and mode == 'r':
        f = sys.stdin
    elif filename == '-' and mode == 'w':
        f = sys.stdout
    else:
        f = open(filename, mode)
    return f

def show_usage():
    sys.exit('''usage: %s [input-file] [output-file]

Puts a prefix in front of all module names, to prevent Quartus from
complaining about conflicts with its built-in library. Warning: uses
global search-and-replace and does not properly parse the Verilog
code! Use at your own risk.'''%sys.argv[0])

if __name__ == '__main__':
    if '--help' in sys.argv: show_usage()
    if '-h' in sys.argv: show_usage()
    if   len(sys.argv) == 1: show_usage()
    elif len(sys.argv) == 2:
        infile = openOrStd(sys.argv[1])
        outfile = sys.stdout
    elif len(sys.argv) == 3:
        infile = openOrStd(sys.argv[1])
        outfile = openOrStd(sys.argv[2], 'w')
    else: show_usage()

    text = infile.read()
    infile.close()
    modules = getModuleNames(text)

    for modname in modules:
        mangled = mangleName(modname)
        text = re.sub(r'([\s;,()])%s([^a-zA-Z_$0-9])'%modname, r'\1%s\2'%mangled, text)

    outfile.write(text)
    outfile.close()
