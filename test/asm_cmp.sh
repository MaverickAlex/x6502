#!/usr/bin/env bash
ca65 -l 6502_functional_test.lst 6502_functional_test.ca65
ld65 6502_functional_test.o -o 6502_functional_test.bin -m 6502_functional_test.map -C example.cfg

