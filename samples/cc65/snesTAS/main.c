#include <peekpoke.h>
#include <stdlib.h>
#include <stdio.h>

#define PORTB           0x6000
#define PORTA           0x6001
#define DDRB            0x6002
#define DDRA            0x6003
#define T1CL            0x6004 //T1 Low Order Latches/Counter
#define T1CH            0x6005 //T1 High Order Counter
#define T1LL            0x6006 //T1 Low Order Latches
#define T1LH            0x6007 //T1 High Order Latches
                      //0x6008 = T2 Low Order Latches/Counter
                      //0x6009 = T2 High Order Counter
#define SHIFTREG        0x600A //Shift Register
#define AUXCONTROL      0x600B //Auxiliary Control Register
                      //0x600C = Peripheral Control Register
#define IRQ_FLAG        0x600d //Interrupt Flag Register
#define IRQ_ENABLE_REG  0x600e //Interrupt Enable Register
                      //0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)

#define BUS_INPUT  0x00
#define BUS_OUTPUT 0xFF

#define LCD_RW   0x40 
#define LCD_E    0x80
#define LCD_RS   0x20

#define LCD_DISPLAY_ON 0x0E
#define LCD_MODE 0x38

char portb_buffer = 0;
/*
check if lcd is busy
*/
short lcd_isBusy()
{
  POKE(DDRB, BUS_INPUT); // set port b in
  POKE(PORTA, LCD_RW);
  POKE(PORTA, LCD_RW | LCD_E); 
  portb_buffer = PEEK(PORTB);
  POKE(PORTA, LCD_RW);
  return portb_buffer & 0x80;
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
  for(c = str; *c != '\0'; c++ )
  {
    print(*c);
  }
}

unsigned int myInt = 0xffff;
char numberString[5];
char outputString [40];
int main()
{

  utoa(myInt, numberString, 10);
  init_lcd();
  

  sprintf(outputString, "%s -> %u",numberString, myInt);
  print_str(outputString);

  
  

  
  
  
  while(1);
  return (0);
}
