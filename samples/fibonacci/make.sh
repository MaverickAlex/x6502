if vasm6502_oldstyle -dotdir -wdc02 -Fbin fibonacci.asm -L fibonacci.lst -o fibonacci.bin; then
  hexdump -C fibonacci.bin
fi
