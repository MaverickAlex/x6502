#!/bin/bash


# ld65 -o snesTAS.bin -C sbc.cfg -m main.map interrupt.o vectors.o wait.o  main.o lcd.o sbc.lib

cl65 -C sbc.cfg -t none --cpu 65C02  -g -Oi main.c lcd.c interrupt.s vectors.s wait.s sbc.lib -o snesTAS.bin
