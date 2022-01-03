#include <peekpoke.h>
#include <stdlib.h>
#include <stdio.h>
// #include <string.h>

#include "lcd.h"
#include "io.h"


unsigned int myInt = 0x33;

unsigned char outputString[60] = "abcdefghijklmnopqrstuvwxyz01234567890ABC";
int main()
{
  utoa(myInt, outputString, 10);
  lcd_init();
  print_str(outputString);
  lcd_clearScreen();
  myInt = 0xFFFF;
  utoa(myInt, outputString, 10);
  print_str(outputString);
  return (0);
}
