#!/bin/bash

cc65 -t none -O --cpu 65sc02 main.c
ca65 --cpu 65sc02 main.s
ca65 --cpu 65sc02 interrupt.s
ca65 --cpu 65sc02 vectors.s
ca65 --cpu 65sc02 wait.s
ld65 -o snesTAS.bin -C sbc.cfg -m main.map interrupt.o vectors.o wait.o  main.o sbc.lib