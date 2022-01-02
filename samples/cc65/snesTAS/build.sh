#!/bin/bash

# cc65 -t none -O --cpu 6502 main.c
# cc65 -t none -O --cpu 6502 lcd.c
# ca65 --cpu 6502 lcd.s
# ca65 --cpu 6502 main.s
# ca65 --cpu 6502 interrupt.s
# ca65 --cpu 6502 vectors.s
# ca65 --cpu 6502 wait.s
# ld65 -o snesTAS.bin -C sbc.cfg -m main.map interrupt.o vectors.o wait.o  main.o lcd.o sbc.lib

cl65 -C sbc.cfg -t none --cpu 65C02  -g -Oi main.c lcd.c interrupt.s vectors.s wait.s sbc.lib -o snesTAS.bin