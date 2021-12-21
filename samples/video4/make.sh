#!/bin/bash

vasm6502_oldstyle -wdc02 -dotdir -Fbin hello.asm -L hello.lst -o hello.bin
hexdump -C hello.bin
