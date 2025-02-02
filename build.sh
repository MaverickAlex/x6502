#!/bin/bash
EXECUTABLE="x6502"
LDFLAGS="-O3 -lpthread -Wall -lncurses"
SRCDIR=src

objects_string=""
for i in $(find src -type f -name "*.c" | sed -e 's/\.c$//');
do
	gcc -I $SRCDIR -c $i".c" -o $i".o" -g
	objects_string="$objects_string "$i".o "
done;

gcc -o $EXECUTABLE $objects_string $LDFLAGS

rm $objects_string
cp $EXECUTABLE ~/bin/
rm $EXECUTABLE