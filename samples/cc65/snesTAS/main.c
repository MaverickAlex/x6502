#include <peekpoke.h>
#include <stdlib.h>
#include <stdio.h>

#include "lcd.h"
#include "io.h"



unsigned int myInt = 0xffff;
char numberString[5];
char outputString [40];
unsigned int size ;
int main()
{

  utoa(myInt, numberString, 10);
  init_lcd();
  

  size = sprintf(outputString, "%s -> %u",numberString, myInt);
  // print_str(outputString);
  sprintf(outputString, "Size:%u", size);
  print_str(outputString);
  
  

  
  
  
  while(1);
  return (0);
}
