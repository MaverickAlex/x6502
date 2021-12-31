#!/bin/bash

cc65 -t none -O --cpu 6502 main.c
ca65 --cpu 6502 main.s
ca65 --cpu 6502 interrupt.s
ca65 --cpu 6502 vectors.s
ca65 --cpu 6502 wait.s
ld65 -o snesTAS.bin -C sbc.cfg -m main.map interrupt.o vectors.o wait.o  main.o sbc.lib
