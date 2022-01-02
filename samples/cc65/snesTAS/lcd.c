#include "lcd.h"

unsigned char lcd_portb_buffer = 0;

void lcd_clearScreen()
{
  lcd_instruction(LCD_CMD_CLEARSCREEN);
  lcd_instruction(LCD_CMD_RETURNHOME);
}


/*
check if lcd is busy
*/
bool lcd_isBusy()
{
  POKE(DDRB, BUS_INPUT); // set port b in
  POKE(PORTA, LCD_RW);
  POKE(PORTA, LCD_RW | LCD_E); 
  lcd_portb_buffer = PEEK(PORTB);
  POKE(PORTA, LCD_RW);
  return (bool) lcd_portb_buffer & 0x80;
}



/*
send instrcutions to lcd screen.
*/
void lcd_instruction(short command)
{
  while( lcd_isBusy() );
  POKE(DDRB, BUS_OUTPUT );
  
  POKE(PORTB, command);
  POKE(PORTA,0x00);
  POKE(PORTA, LCD_E);
  POKE(PORTA, 0x00);
  
}
/*
inialize the lcd screen.
*/
void init_lcd()
{
  POKE(DDRB, BUS_OUTPUT);
  POKE(DDRA, BUS_OUTPUT);
  lcd_instruction(LCD_MODE);
  lcd_instruction(LCD_DISPLAY_ON);

}

void print(unsigned char c)
{
  while(lcd_isBusy());
  POKE(DDRB, BUS_OUTPUT);
  POKE(PORTB, c);
  POKE(PORTA, LCD_RS);
  POKE(PORTA, LCD_E | LCD_RS);
  POKE(PORTA, LCD_RS);
}

void print_str(unsigned char * str)
{
  unsigned char * c;
  for(c = str; *c != '\0'; ++c )
  {
    print(*c);
  }
}