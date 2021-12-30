

int *PORTB = (int *) 0x6000; 
int *PORTA = (int *) 0x6001; 
int *DDRB  = (int *) 0x6002; 
int *DDRA  = (int *) 0x6003; 

int E_bit =  0x80;
int RW_bit =  0x40;
int RS_bit =  0x20;

int lcd_cmd_8BIT = 0x38;  //Set 8-bit mode; 2-line display; 5x8 font
int lcd_cmd_DisplayOn = 0x0E;  //Display on; cursor on; blink off
int lcd_cmd_Clear = 0x01;  //clear 
int lcd_cmd_Home =  0x02;   //return home
int lcd_isBusy()
{
  *DDRB = 0x00; //set port b to input
  *PORTA = RW_bit; 
  *PORTA = RW_bit | E_bit; //trigger e bit to 
  return  *PORTB && 0x80;
}

void execute_lcd_instruction(int cmd)
{
  while(lcd_isBusy());
  *PORTB = cmd;
  *PORTA = E_bit;
  *PORTA = 0x00;
}

void init_lcd()
{
  *DDRB = 0xff;
  *DDRA = 0xE0;
  execute_lcd_instruction(lcd_cmd_8BIT);
  execute_lcd_instruction(lcd_cmd_DisplayOn);
  execute_lcd_instruction(lcd_cmd_Clear);
}

int main()
{
  init_lcd();
  return (0);
}





