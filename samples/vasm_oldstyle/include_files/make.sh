if vasm6502_oldstyle -dotdir -wdc02 -Fbin include_files.asm -L include_files.lst -o include_files.bin; then
  hexdump -C include_files.bin
fi