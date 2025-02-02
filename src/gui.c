#include <ncurses.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/time.h>

#include "gui.h"
#include "io.h"
#include "lcd.h"

#include "functions.h"
#include "opcodes.h"

#define LCD_HEIGHT (LCD_DISPLAY_ROWS) + 2
#define LCD_WIDTH (LCD_DISPLAY_COLS) + 2

#define LCD_ORIGINX 0
#define LCD_ORIGINY 0

#define MONITOR_ROWS 5
#define MONITOR_COLS 36

#define MONITOR_HEIGHT (MONITOR_ROWS) + 2
#define MONITOR_WIDTH (MONITOR_COLS) + 2

#define PORTMON_ROWS 4
#define PORTMON_COLS 36

#define PORTMON_HEIGHT (MONITOR_ROWS) + 2
#define PORTMON_WIDTH (MONITOR_COLS) + 2

#define TRACE_ROWS 20
#define TRACE_COLS 36

#define TRACE_HEIGHT (TRACE_ROWS) + 2
#define TRACE_WIDTH (TRACE_COLS) + 2

#define MONITOR_ORIGINX 0
#define MONITOR_ORIGINY (LCD_ORIGINY) + (LCD_HEIGHT)

#define PORTMON_ORIGINX (MONITOR_ORIGINX)
#define PORTMON_ORIGINY (MONITOR_ORIGINY) + (MONITOR_HEIGHT)

#define TRACE_ORIGINX (PORTMON_ORIGINX)
#define TRACE_ORIGINY (PORTMON_ORIGINY) + (PORTMON_HEIGHT)

#define MEMORY_ROWS 32
#define MEMORY_COLS 74

#define MEMORY_HEIGHT (MEMORY_ROWS) + 2
#define MEMORY_WIDTH (MEMORY_COLS) + 2

#define MEMORY_ORIGINX (TRACE_ORIGINX) + (TRACE_WIDTH)
#define MEMORY_ORIGINY (MONITOR_ORIGINY)

#define CYCLES_SKIP 50

uint8_t io_supports_paint;

uint8_t memory_start = 0x00;

int input_cycle_skip = 0;

WINDOW *window = NULL;
WINDOW *wnd_lcd = NULL;
WINDOW *wnd_lcd_content = NULL;
WINDOW *wnd_monitor = NULL;
WINDOW *wnd_monitor_content = NULL;
WINDOW *wnd_portmon = NULL;
WINDOW *wnd_portmon_content = NULL;
WINDOW *wnd_trace = NULL;
WINDOW *wnd_trace_content = NULL;
WINDOW *wnd_memory = NULL;
WINDOW *wnd_memory_content = NULL;

void init_gui()
{
  initscr();
  cbreak();
  noecho();
  nodelay(stdscr, TRUE);
  keypad(stdscr, TRUE);
  curs_set(0);

  io_supports_paint = (has_colors() != FALSE);
  if (io_supports_paint)
  {
    start_color();
    for (int i = 0; i < 8; i++)
    {
      init_pair(i, i, COLOR_BLACK);
      init_pair(i + 8, i, COLOR_WHITE);
    }
  }

  wnd_lcd = newwin(LCD_HEIGHT, LCD_WIDTH, LCD_ORIGINY, LCD_ORIGINX);
  wnd_lcd_content = newwin(LCD_DISPLAY_ROWS, LCD_DISPLAY_COLS, LCD_ORIGINY + 1, LCD_ORIGINX + 1);
  wnd_monitor = newwin(MONITOR_HEIGHT, MONITOR_WIDTH, MONITOR_ORIGINY, MONITOR_ORIGINX);
  wnd_monitor_content = newwin(MONITOR_ROWS, MONITOR_COLS, MONITOR_ORIGINY + 1, MONITOR_ORIGINX + 1);
  wnd_portmon = newwin(PORTMON_HEIGHT, PORTMON_WIDTH, PORTMON_ORIGINY, PORTMON_ORIGINX);
  wnd_portmon_content = newwin(PORTMON_ROWS, PORTMON_COLS, PORTMON_ORIGINY + 1, PORTMON_ORIGINX + 1);
  wnd_trace = newwin(TRACE_HEIGHT, TRACE_WIDTH, TRACE_ORIGINY, TRACE_ORIGINX);
  wnd_trace_content = newwin(TRACE_ROWS, TRACE_COLS, TRACE_ORIGINY + 1, TRACE_ORIGINX + 1);
  wnd_memory = newwin(MEMORY_HEIGHT, MEMORY_WIDTH, MEMORY_ORIGINY, MEMORY_ORIGINX);
  wnd_memory_content = newwin(MEMORY_ROWS, MEMORY_COLS, MEMORY_ORIGINY + 1, MEMORY_ORIGINX + 1);
  scrollok(wnd_trace_content, TRUE);
  refresh();
  box(wnd_lcd, 0, 0);
  wcolor_set(wnd_lcd, 8, NULL);
  mvwprintw(wnd_lcd, 0, 1, " LCD ");
  box(wnd_monitor, 0, 0);
  wcolor_set(wnd_monitor, 8, NULL);
  mvwprintw(wnd_monitor, 0, 1, " CPU Monitor ");
  box(wnd_portmon, 0, 0);
  wcolor_set(wnd_portmon, 8, NULL);
  mvwprintw(wnd_portmon, 0, 1, " Ports Monitor ");
  box(wnd_trace, 0, 0);
  wcolor_set(wnd_trace, 8, NULL);
  mvwprintw(wnd_trace, 0, 1, " Bus Trace ");
  box(wnd_memory, 0, 0);
  wcolor_set(wnd_memory, 8, NULL);
  mvwprintw(wnd_memory, 0, 1, " Memory  ");
  wrefresh(wnd_lcd);
  wrefresh(wnd_monitor);
  wrefresh(wnd_portmon);
  wrefresh(wnd_trace);
  wrefresh(wnd_memory);

  int screen_width, screen_height;
  getmaxyx(stdscr, screen_height, screen_width);
  int size = snprintf(NULL, 0, "Height %d, Width %d\n", screen_height, screen_width);
  char *screen_msg = (char *)malloc((size + 1) * sizeof(char));
  snprintf(screen_msg, size + 1, "Height %d, Width %d\n", screen_height, screen_width);
  trace_emu(screen_msg);
  free(screen_msg);
}

void finish_gui()
{
  nodelay(stdscr, FALSE);
  trace_emu("\nterminated, press any key to exit.\n");
  while (getch() == ERR)
    ;

  endwin();
}

void trace_emu(const char *msg)
{
  wprintw(wnd_trace_content, msg);
  wrefresh(wnd_trace_content);
}

void update_gui(cpu *m)
{
  int read = 0;
  bool keep_going = false;

  do
  {

    // update LCD contents
    if (!(m->l->initialized))
    {
      for (int y = 0; y < LCD_DISPLAY_ROWS; y += 2)
      {
        for (int x = 0; x < LCD_DISPLAY_COLS; x++)
        {
          wcolor_set(wnd_lcd_content, 8, NULL);
          mvwprintw(wnd_lcd_content, y, x, " ", x);
          wcolor_set(wnd_lcd_content, 7, NULL);
          mvwprintw(wnd_lcd_content, y + 1, x, " ");
        }
      }
    }
    else
    {
      for (int y = 0; y < LCD_DISPLAY_ROWS; y++)
      {
        for (int x = 0; x < LCD_DISPLAY_COLS; x++)
        {
          int memloc = (y * LCD_COLS) + x;
          if (isprint(m->l->ddram[memloc]))
          {
            mvwprintw(wnd_lcd_content, y, x, "%c", m->l->ddram[memloc]);
          }
          else
          {
            mvwprintw(wnd_lcd_content, y, x, " ");
          }
        }
      }
    }
    wrefresh(wnd_lcd_content);

    // start by populating the monitor
    mvwprintw(wnd_monitor_content, 0, 0, "PC: %04x, OP: %02x (%s)", m->pc_actual, m->opcode, translate_opcode(m->opcode));
    mvwprintw(wnd_monitor_content, 1, 0, "ACC-> '%c', %02x, %03u, %04d, %c%c%c%c%c%c%c%c",
              isprint(m->ac) ? m->ac : '~',
              m->ac,
              m->ac,
              (int8_t)m->ac,
              m->ac & 0x80 ? '1' : '0',
              m->ac & 0x40 ? '1' : '0',
              m->ac & 0x20 ? '1' : '0',
              m->ac & 0x10 ? '1' : '0',
              m->ac & 0x08 ? '1' : '0',
              m->ac & 0x04 ? '1' : '0',
              m->ac & 0x02 ? '1' : '0',
              m->ac & 0x01 ? '1' : '0');
    mvwprintw(wnd_monitor_content, 2, 0, "X: %02x, Y: %02x, SP: %02x", m->x, m->y, m->sp);

    mvwprintw(wnd_monitor_content, 3, 0, "SR: %c%c-%c%c%c%c%c, cycle: %08x",
              m->sr & 0x80 ? 'N' : '-',
              m->sr & 0x40 ? 'V' : '-',
              m->sr & 0x10 ? 'B' : '-',
              m->sr & 0x08 ? 'D' : '-',
              m->sr & 0x04 ? 'I' : '-',
              m->sr & 0x02 ? 'Z' : '-',
              m->sr & 0x01 ? 'C' : '-',
              m->cycle);
    mvwprintw(wnd_monitor_content, 4, 0, "Clock mode: %s", m->clock_mode == CLOCK_FAST ? "FAST" : m->clock_mode == CLOCK_SLOW ? "SLOW"
                                                                                                                              : "STEP");
    wrefresh(wnd_monitor_content);

    // populate memory monitor
    mvwprintw(wnd_memory, 0, 10, "%04x:%04x ", (memory_start << 8), (memory_start << 8) + 0x01FF);
    wrefresh(wnd_memory);

    for (int off16 = 0; off16 < 32; off16++)
    {
      mvwprintw(wnd_memory_content, off16, 0, "%04x", (memory_start << 8) + off16 * 0x10);
      for (int offset = 0; offset < 16; offset++)
      {
        uint16_t curAddress = ((memory_start << 8) + off16 * 0x10 + offset);
        if (m->pc_actual == curAddress)
        {
          wcolor_set(wnd_memory_content, COLOR_RED, NULL);
        }
        if (m->dirty_mem_addr == curAddress)
        {
          wcolor_set(wnd_memory_content, COLOR_YELLOW, NULL);
        }
        if (m->read_mem_addr == curAddress)
        {
          wcolor_set(wnd_memory_content, COLOR_GREEN, NULL);
        }
        switch (m->opcode)
        {
#include "memory_highlights/store.h"
#include "memory_highlights/load.h"
#include "memory_highlights/jump.h"
        }

        mvwprintw(wnd_memory_content, off16, 6 + offset * 3, "%02x ", m->mem[curAddress]);
        mvwprintw(wnd_memory_content, off16, 56 + offset, "%c", isprint(m->mem[curAddress]) ? m->mem[curAddress] : '.');
        wcolor_set(wnd_memory_content, COLOR_WHITE, NULL);
      }
    }
    wrefresh(wnd_memory_content);

    // populate ports monitor
    mvwprintw(wnd_portmon_content, 0, 0, "0-V1PA-7 0-V1PB-7 0-V2PA-7 0-V2PB-7");
    uint8_t bitmask = 0x01;
    for (int bit = 0; bit < 8; bit++)
    {
      mvwprintw(wnd_portmon_content, 1, bit, "%c", m->v1->ddra & bitmask ? 'O' : 'i');
      mvwprintw(wnd_portmon_content, 2, bit, "%c", m->v1->porta & bitmask ? '1' : '0');
      mvwprintw(wnd_portmon_content, 1, bit + 9, "%c", m->v1->ddrb & bitmask ? 'O' : 'i');
      mvwprintw(wnd_portmon_content, 2, bit + 9, "%c", m->v1->portb & bitmask ? '1' : '0');
      bitmask = bitmask << 1;
    }
    wrefresh(wnd_portmon_content);

    if (m->clock_mode == CLOCK_SPRINT && input_cycle_skip < CYCLES_SKIP)
    {
      input_cycle_skip++;
    }
    else
    {
      input_cycle_skip = 0;
      reset_keys(m->k);

      switch (m->clock_mode)
      {
      case CLOCK_SPRINT:
        read = getch();
        keep_going = true;
        break;
      case CLOCK_FAST:
        halfdelay(1);
        read = getch();
        keep_going = true;
        break;
      case CLOCK_SLOW:
        halfdelay(10);
        read = getch();
        keep_going = true;
        break;
      case CLOCK_STEP:
        while ((read = getch()) == ERR)
          ;
        break;
      }

      switch (read)
      {
      case ERR:
        break;
      case KEY_F(5): // F5
        keep_going = true;
        break;
      case KEY_F(6): // F6
        if (!(m->clock_mode == CLOCK_SPRINT))
        {
          m->clock_mode = CLOCK_STEP;
        }
        break;
      case KEY_F(7): // F7
        if (!(m->clock_mode == CLOCK_SPRINT))
        {
          m->clock_mode = CLOCK_SLOW;
        }
        break;
      case KEY_F(8): // F8
        if (!(m->clock_mode == CLOCK_SPRINT))
        {
          m->clock_mode = CLOCK_FAST;
        }
        break;

      case 'r':
      case 'R':
        m->k->sw1_reset = true;
        keep_going = true;
        break;
      case '1':
        m->k->sw2_key = false;
        keep_going = true;
        break;
      case '2':
        m->k->sw3_key = false;
        keep_going = true;
        break;
      case '3':
        m->k->sw4_key = false;
        keep_going = true;
        break;
      case '4':
        m->k->sw5_key = false;
        keep_going = true;
        break;
      case '5':
        m->k->sw6_key = false;
        keep_going = true;
        break;
      case '[':
        if (memory_start > 0x00)
        {
          memory_start--;
        }
        break;
      case '{':
        if (memory_start > 0x10)
        {
          memory_start -= 0x10;
        }
        else
        {
          memory_start = 0;
        }
        break;
      case ']':
        if (memory_start < (0xff - 0x01))
        {
          memory_start++;
        }
        break;
      case '}':
        if (memory_start < (0xff - 0x10))
        {
          memory_start += 0x10;
        }
        else
        {
          memory_start = 0xfe;
        }
        break;
      }
    }
  } while (!keep_going && m->clock_mode != CLOCK_SPRINT);
}