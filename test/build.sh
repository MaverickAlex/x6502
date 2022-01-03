#!/bin/bash

cc65 -t none -O --cpu 65C02 main.c
ca65 --cpu 65C02 main.s
ca65 --cpu 65C02 6502_functional_test.s
ca65 --cpu 65C02 interrupt.s
ca65 --cpu 65C02 vectors.s
ca65 --cpu 65C02 wait.s
ld65 -C sbc.cfg -m main.map interrupt.o vectors.o wait.o 6502_functional_test.o main.o sbc.lib