#ifndef LCD_HEADER
#define LCD_HEADER
#include <peekpoke.h>
#include <stdbool.h>
#include "io.h"


#define LCD_RW   0x40 
#define LCD_E    0x80
#define LCD_RS   0x20

#define LCD_CMD_CLEARSCREEN       0x01
#define LCD_CMD_RETURNHOME        0x02
#define LCD_CMD_ENTRYMODE         0x04
#define LCD_CMD_DISPLAYCONTROL    0x08
#define LCD_CMD_SHIFT             0x10
#define LCD_CMD_FUNCTION          0x20
#define LCD_CMD_CGRAM             0x40
#define LCD_CMD_DDRAM             0x80

#define LCD_DISPLAY_ON 0x0E
#define LCD_MODE 0x38



void lcd_clearScreen(void);

bool lcd_isBusy(void);
void print_str(unsigned char * str);
void print(unsigned char c);
void init_lcd(void);
void lcd_instruction(short command);

#endif