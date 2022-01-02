#include <peekpoke.h>
#include <stdlib.h>
#include <stdio.h>
// #include <string.h>

#include "lcd.h"
#include "io.h"



unsigned int myInt = 0xffff;
unsigned char numberString[10] = "1";
unsigned char outputString [40] = "abc";
unsigned int size ;
int main()
{

  // utoa(myInt, numberString, 10);
  init_lcd();
  

  // size = sprintf(outputString, "%s -> %u",numberString, myInt);
  print_str(numberString);

  //print_str(numberString);
  while(1);
  // memset(outputString,0,40);
  // sprintf(outputString, "Size:%u", size);
  // print_str(outputString);
  lcd_clearScreen();
  print_str("2");
  

  
  
  
  while(1);
  return (0);
}
