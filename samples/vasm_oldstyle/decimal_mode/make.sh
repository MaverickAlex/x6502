if vasm6502_oldstyle -dotdir -wdc02 -Fbin decimal_mode.asm -L decimal_mode.lst -o decimal_mode.bin; then
  hexdump -C decimal_mode.bin
fi
