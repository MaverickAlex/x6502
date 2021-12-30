if vasm6502_oldstyle -dotdir -wdc02 -Fbin convert_binary_decimal.asm -L convert_binary_decimal.lst -o convert_binary_decimal.bin; then
  hexdump -C convert_binary_decimal.bin
fi
