#!/bin/bash

vasm6502_oldstyle -wdc02 -dotdir -Fbin video5.asm -L video5.lst -o video5.bin
hexdump -C video5.bin
