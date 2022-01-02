#include <peekpoke.h>
#include <stdlib.h>
#include <stdio.h>
// #include <string.h>

#include "lcd.h"
#include "io.h"



unsigned int myInt = 0xffff;
char numberString[5];
char outputString [40];
unsigned int size ;
int main()
{

  // utoa(myInt, numberString, 10);
  init_lcd();
  

  // size = sprintf(outputString, "%s -> %u",numberString, myInt);
  print_str("1");
  print_str("2");
  // memset(outputString,0,40);
  // sprintf(outputString, "Size:%u", size);
  // print_str(outputString);
  lcd_clearScreen();
  print_str("2");
  

  
  
  
  while(1);
  return (0);
}
