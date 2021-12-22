#!/bin/bash

vasm6502_oldstyle -wdc02 -dotdir -Fbin video4.asm -L video4.lst -o video4.bin
hexdump -C video4.bin
