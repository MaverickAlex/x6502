if vasm6502_oldstyle -dotdir -wdc02 -Fbin via_chip.asm -L via_chip.lst -o via_chip.bin; then
  hexdump -C via_chip.bin
fi
