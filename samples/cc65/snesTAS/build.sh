#!/bin/bash


# ld65 -o snesTAS.bin -C sbc.cfg -m main.map interrupt.o vectors.o wait.o  main.o lcd.o sbc.lib

cl65 -C sbc.cfg -t none --cpu 65C02  -g -Oi main.c lcd.c interrupt.s vectors.s wait.s sbc.lib -o snesTAS.bin

cc65 -t none -O --cpu 65C02 main.c
cc65 -t none -O --cpu 65C02 lcd.c
ca65 --cpu 65C02 lcd.s
ca65 --cpu 65C02 main.s
ca65 --cpu 65C02 interrupt.s
ca65 --cpu 65C02 vectors.s
ca65 --cpu 65C02 wait.s