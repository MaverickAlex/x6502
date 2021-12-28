if vasm6502_oldstyle -dotdir -wdc02 -Fbin pi.asm -L pi.lst -o pi.bin; then
  hexdump -C pi.bin
fi