#include "lcd.h"
#include "gui.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

lcd *new_lcd()
{
  lcd *l = malloc(sizeof(lcd));

  l->initialized = false;
  l->enable_latch = false;
  l->fourbit_mode = false;
  l->lower_bits = false;
  l->function = 0;
  l->entry_mode = 0;
  l->display_mode = 0;
  l->data = 0xff;
  l->cursor = 0;
  memset(l->ddram, 0x00, LCD_MEM_SIZE);
  return l;
}

void destroy_lcd(lcd *l)
{
  free(l);
}

void process_command(lcd *l, bool rwb, uint8_t input);
void process_data(lcd *l, bool rwb, uint8_t input);
void rotateLeftOne(lcd *l);
void rotateRightOne(lcd *l);


void process_input(lcd *l, bool enable, bool rwb, bool data, uint8_t input)
{
  char message[32];
  if (enable && !l->enable_latch)
  { // rising edge on enable
    l->enable_latch = true;
    trace_emu("LCD rising edge on enable\n");
    if (!l->initialized && !(input & 0xc0) && (input & CMD_FUNCTION_SET) && !rwb)
    {
      trace_emu("LCD initializing \n");
      l->initialized = true;
      if (input & CMD_FS_8_BIT)
      {
        trace_emu("LCD 8-bit mode\n");
        l->fourbit_mode = false;
      }
      else
      {
        trace_emu("LCD 4-bit mode\n");
        l->fourbit_mode = true;
      }
    }
    if (l->initialized)
    {
      // when in 4-bit mode
      if (l->fourbit_mode)
      {
        // if these are most significant bits
        if (!l->lower_bits)
        {
          // store them in msb latch
          l->data_msb = input;
          // indicate we are waiting for lsb
          l->lower_bits = true;
          sprintf(message, "LCD received 4-bits, msb: %01x\n", (input & 0xf0));
        }
        else
        {
          // not waiting anymore
          l->lower_bits = false;
          // store them in lsb latch
          l->data_lsb = input;
          // move full byte to data latch
          l->data = (l->data_msb & 0xf0) | ((l->data_lsb & 0xf0) >> 4);
          sprintf(message, "LCD received 4-bits, lsb: %01x\n", (input & 0xf0));
        }
      }
      else
      {
        // simply move input to data latch
        sprintf(message, "LCD received 8-bits: %02x\n", input);
        l->data = input;
      }
      trace_emu(message);
      if (!l->fourbit_mode || !l->lower_bits)
      {
        // we are either in 4-bit mode and received both halves or in 8-bit mode
        if (!data)
        {
          process_command(l, rwb, l->data);
        }
        else
        {
          process_data(l, rwb, l->data);
        }
      }
    }
  }
  else if (!enable && l->enable_latch)
  { // falling edge on enable
    trace_emu("LCD falling edge on enable\n");
    l->enable_latch = false;
    l->data = 0xff;
  }
}

void process_command(lcd *l, bool rwb, uint8_t input)
{
  char message[32];
  if (!rwb)
  { // write operations
    if ((input & CMD_FUNCTION_SET) && !(input & 0xc0))
    {
      l->function = input;
      snprintf(message, sizeof(message), "LCD function set to %02x\n", input);
      trace_emu(message);
    }
    else if ((input & CMD_DISPLAY_MODE) && !(input & 0xf0))
    {
      l->display_mode = input;
      sprintf(message, "LCD display mode set to %02x\n", input);
      trace_emu(message);
    }
    else if ((input & CMD_SHIFT) && !(input & 0xe0))
    {
      l->display_mode = input;
      sprintf(message, "LCD shift mode set to %02x\n", input);
      trace_emu(message);
      //find out if we need to increment cusor or shift display
      if((input & CMD_SHIFT_DISPLAY) > 0)
      {
        trace_emu("SHIFT DISPLAY ");
        if((input & CMD_SHIFT_RIGHT) > 0)
        {
          rotateRightOne(l);
          trace_emu("RIGHT\n");
        }
        else
        {
          rotateLeftOne(l);
          trace_emu("LEFT\n");
        }
      }
      else
      {
        trace_emu("SHIFT CURSOR ");
        if((input & CMD_SHIFT_RIGHT) > 0)
        {
          l->cursor++;
          trace_emu("RIGHT\n");
        }
        else
        {
          l->cursor--;
          trace_emu("LEFT\n");
        }
      }
    }
    else if ((input & CMD_ENTRY_MODE) && !(input & 0xf8))
    {
      l->display_mode = input;
      sprintf(message, "LCD entry mode set to %02x\n", input);
      trace_emu(message);
    }
    else if ((input & CMD_HOME) && !(input & 0xfc))
    {
      trace_emu("LCD moving to home location\n");
      l->cursor = 0;
    }
    else if ((input & CMD_CLEAR) && !(input & 0xfc))
    {
      trace_emu("LCD clearing screen\n");
      memset(l->ddram, 0x00, LCD_MEM_SIZE);
    }
    else if ((input & CMD_DDRAM_SET))
    {
      sprintf(message, "LCD cursor address set to %02x\n", input & 0x7f);
      trace_emu(message);
      l->cursor = input & 0x7f;
    }
  }
  else
  {
    l->data = l->cursor;
  }
}
void process_data(lcd *l, bool rwb, uint8_t input)
{
  char message[32];
  if (!rwb)
  { // write operation
    sprintf(message, "LCD write %02x to location %02x\n", input, l->cursor);
    trace_emu(message);
    l->ddram[l->cursor++] = input;
    if (l->cursor == LCD_ROWS * LCD_COLS)
    {
      l->cursor = 0;
    }
  }
}

void rotateRightOne(lcd * l)
{
  uint8_t row,col,temp,col_min, col_max;
  //each row
  for(row = 0; row <= LCD_ROWS; row++)
  {
    col_min = (LCD_COLS * row);
    col_max = (LCD_COLS * row) + LCD_COLS -1;
    //get last item in row  
    temp = l->ddram[col_max];
    //walk backwards 
    for(col=col_max; col > col_min; col--)
    {
      l->ddram[col] = l->ddram[col - 1];
    }
    l->ddram[col_min] = temp;
  }
}

void rotateLeftOne(lcd * l)
{
  uint8_t row,col,temp,col_min, col_max;
  //each row
  for(row = 0; row <= LCD_ROWS; row++)
  {
    col_min = (LCD_COLS * row);
    col_max = (LCD_COLS * row) + LCD_COLS -1;
    //get last item in row  
    temp = l->ddram[col_min];
    //walk forwards 
    for(col=col_min; col < col_max; col++)
    {
      l->ddram[col] = l->ddram[col + 1];
    }
    l->ddram[col_max] = temp;
  }
}