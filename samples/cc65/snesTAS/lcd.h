#ifndef LCD_HEADER
#define LCD_HEADER
#include <peekpoke.h>
#include <stdbool.h>
#include "io.h"




bool lcd_isBusy(void);
void print_str(unsigned char * str);
void print(unsigned char c);
void init_lcd(void);
void lcd_instruction(short command);

#endif