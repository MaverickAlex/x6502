#include "io.h"
#include "lcd.h"

#include <ncurses.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/time.h>

#include "functions.h"
#include "opcodes.h"

void init_io()
{
}

void finish_io()
{
}

void handle_io(cpu *m, bool rwb)
{
  if (!rwb)
  {
    // data potentially written to memory
    if (get_emu_flag(m, EMU_FLAG_DIRTY))
    {
      uint16_t addr = m->dirty_mem_addr;

      if ((addr & 0x4000) && (addr & 0x2000) && !(addr & 0x8000))
      {
        switch (addr)
        {
        case VIA1_PORTB:
          m->v1->portb &= (~m->v1->ddrb);
          m->v1->portb |= (m->mem[addr] & m->v1->ddrb);
          break;
        case VIA1_PORTA:
          m->v1->porta &= (~m->v1->ddra);
          m->v1->porta |= (m->mem[addr] & m->v1->ddra);
          break;
        case VIA1_DDRB:
          m->v1->ddrb = m->mem[addr];
          break;
        case VIA1_DDRA:
          m->v1->ddra = m->mem[addr];
          break;
        case VIA1_TIMER1_CH:
        case VIA1_TIMER1_CL:
        case VIA1_TIMER1_LH:
        case VIA1_TIMER1_LL:
          //TODO add these plus the other registers on the via chipset
          break;
        }

        if (m->lcd_8_bit)
        {
          process_input(m->l, m->v1->porta & 0x80, m->v1->porta & 0x40, m->v1->porta & 0x20, m->v1->portb);
        }
        else
        {
          process_input(m->l, m->v1->portb & 0x08, m->v1->portb & 0x04, m->v1->portb & 0x02, m->v1->portb & 0xf0);
        }
      }
    }
  }
  else
  {
    uint8_t old_porta_input = m->v1->porta & ~m->v1->ddra;

    m->v1->portb &= m->v1->ddrb;
    m->v1->portb |= (m->l->data & ~m->v1->ddrb);
    m->v1->porta &= m->v1->ddra;
    m->v1->porta |= m->k->sw2_key ? 0x01 : 0;
    m->v1->porta |= m->k->sw3_key ? 0x02 : 0;
    m->v1->porta |= m->k->sw4_key ? 0x04 : 0;
    m->v1->porta |= m->k->sw5_key ? 0x08 : 0;
    m->v1->porta |= m->k->sw6_key ? 0x10 : 0;

    if (old_porta_input != (m->v1->porta & ~m->v1->ddra))
    {
      m->interrupt_waiting = 0x01;
    }

    // read operation
    m->mem[VIA1_PORTB] = m->v1->portb;
    m->mem[VIA1_PORTA] = m->v1->porta;
    m->mem[VIA1_DDRB] = m->v1->ddrb;
    m->mem[VIA1_DDRA] = m->v1->ddra;
    m->mem[VIA1_TIMER1_CL] = m->v1->t1cl;
    m->mem[VIA1_TIMER1_CH] = m->v1->t1ch;
  }
}
