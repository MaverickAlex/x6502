#!/bin/bash

vasm6502_oldstyle -wdc02 -dotdir -Fbin video6.asm -L video6.lst -o video6.bin
hexdump -C video6.bin
