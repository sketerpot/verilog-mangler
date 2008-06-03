#!/usr/bin/env python
import re
import os, sys

# These symbols need to be changed.
forbiddenNamesCheng = ['BUFF', 'NOR2', 'OR2', 'AND2']
forbiddenNamesExample = ['AND2', 'AND3', 'AND4', 'OR2', 'OR3', 'OR4', 'NAND2', 'NAND3', 'NAND4', 'NOR2', 'NOR3', 'NOR4', 'XOR2', 'XNOR2',
                         'MUTEX', 'BUF', 'BUFF', 'INV', 'LATCH', 'MUX2', 'NMUX2', 'DEMUX2', 'NKEEP', 'TRIBUF', 'TRIINV', 'C2', 'C3',
                         'NC2P', 'C2N', 'VDD', 'GND', 'UDP_NKEEP', 'UDP_demux2_top_half', 'UDP_demux2_bottom_half', 'UDP_MUX2',
                         'UDP_NMUX2', 'UDP_C2', 'UDP_C3', 'UDP_NC2P', 'UDP_C2N', 'UDP_mutex_top_half', 'UDP_mutex_bottom_half', 'UDP_LATCH']

def mangleName(identifier):
    '''Take a Verilog identifier and add a QII_ prefix'''
    return 'QII_%s'%identifier

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
    sys.exit('''usage: %s [-c] [input-file] [output-file]

Puts a QII_ prefix in front of all module names that conflict with the
Quartus built-in library, and possibly some that do not. This should
be compatible with Dr. Cheng\'s modified library file, but by default
it aims for compatibility with my modified version of the
example-cells.v library, QII-example-cells.v

The -c option will limit the replacements to those necessary to work
with Balsa_QII_LIB.v; otherwise, it will aim for completeness.

For more information, consult the vmangle(1) man page.'''%sys.argv[0])

if __name__ == '__main__':
    if '-c' in sys.argv:
        forbiddenNames = forbiddenNamesCheng
        sys.argv.remove('-c')
    else: forbiddenNames = forbiddenNamesExample
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
    
    for modname in forbiddenNames:
        mangled = mangleName(modname)
        text = re.sub(r'([\s;,()])%s([^a-zA-Z_$0-9])'%modname, r'\1%s\2'%mangled, text)

    outfile.write(text)
    outfile.close()
