#include <stddef.h>

#include <6502.h>
#include <peekpoke.h>

#define PORTB     (*(unsigned char *) 0x6000)
#define PORTA     (*(unsigned char *) 0x6001)
#define DDRB     0x6002
#define DDRA     (*(unsigned char *) 0x6003)
#define LCD_RW 0x40 
#define LCD_E 0x80
#define LCD_RS 0x20
#define LCD_ISBUSY (PORTB & 0x80)

const short lcdMode = 0x38; // %00111000 ;0 Set 8-bit mode; 2-line display; 5x8 font
// short lcd_isBusy()
// {
//   //need to read io chip set port b to in
//   DDRB = 0;
//   PORTA = LCD_RW;
//   PORTA = LCD_RW | LCD_E;
//   short result = LCD_ISBUSY == 0;
//   PORTA = LCD_RW;
//   return result ;
// }

// void lcd_instruction(short command)
// {
//   while(lcd_isBusy());
// }
// void init_lcd()
// {
//   //set output ports
//   DDRB = 0xFF;
//   DDRA = 0xE0;
//   //execute mode command
//   lcd_instruction(lcdMode);
// }
short varA;
int main()
{
  POKE(DDRB, 0xff);
  DDRA = 0xff;
  PORTA = 0xaa;
  PORTB = 0xbb;
  varA = PEEK(0x6000);
  PORTA = varA;
  while(1);
  return (0);
}





