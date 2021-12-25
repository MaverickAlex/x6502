#ifndef __6502_FUNCTIONS__
#define __6502_FUNCTIONS__

#include <stdlib.h>

#include "cpu.h"
#include "gui.h"

static const char *memType(uint16_t address)
{
  if (address >= 0x0000 && address <= 0x3fff)
  {
    return "RAM";
  }
  if (address >= 0x6000 && address <= 0x600f)
  {
    return "I/O";
  }
  if (address >= 0x8000)
  {
    return "ROM";
  }
  return "INV";
}

static const bool isValidWrite(uint16_t address)
{
  if (address >= 0x0000 && address <= 0x3fff)
  {
    return true;
  }
  if (address >= 0x6000 && address <= 0x600f)
  {
    return true;
  }
  if (address >= 0x8000)
  {
    return false;
  }
  return false;
}
// mark a memory address as read
static inline void mark_read(cpu *m, uint16_t address)
{
  if (isValidWrite(address))
  {
    // m->emu_flags |= EMU_FLAG_DIRTY;
    m->read_mem_addr = address;
  }
}

static inline uint8_t read_byte(cpu *m, uint16_t address)
{
  static char trace_entry[80];
  sprintf(trace_entry, "Bus addr:%04x mode:r value:%02x %s\n", address, m->mem[address], memType(address));
  trace_emu(trace_entry);
  mark_read(m, address);
  return m->mem[address];
}

static inline uint8_t write_byte(cpu *m, uint16_t address, uint8_t value)
{
  static char trace_entry[80];
  sprintf(trace_entry, "Bus addr:%04x mode:W value:%02x %s\n", address, value, memType(address));
  trace_emu(trace_entry);
  if (isValidWrite(address))
  {
    return m->mem[address] = value;
  }
  return m->mem[address];
}

static inline uint8_t read_next_byte(cpu *m, uint8_t pc_offset)
{
  return read_byte(m, m->pc + pc_offset);
}

static inline void set_pc(cpu *m, uint16_t address)
{
  m->pc = address;
  m->pc_set = true;
}

#define ZP(x) ((uint8_t)(x))
//#define STACK_PUSH(m) (m)->mem[(m)->sp-- + STACK_START]
#define STACK_PUSH(m, v) (write_byte(m, m->sp-- + STACK_START, v))
//#define STACK_POP(m) (m)->mem[++(m)->sp + STACK_START]
#define STACK_POP(m) (read_byte(m, ++(m)->sp + STACK_START))

static inline size_t mem_abs(uint8_t low, uint8_t high, uint8_t off)
{
  return (uint16_t)off + (uint16_t)low + ((uint16_t)high << 8);
}

static inline size_t mem_indirect_index(cpu *m, uint8_t addr, uint8_t off)
{
  //    return mem_abs(m->mem[addr], m->mem[addr+1], off);
  return mem_abs(read_byte(m, addr), read_byte(m, addr + 1), off);
}

static inline size_t mem_indexed_indirect(cpu *m, uint8_t addr, uint8_t off)
{
  //    return mem_abs(m->mem[addr+off], m->mem[addr+off+1], 0);
  return mem_abs(read_byte(m, addr + off), read_byte(m, addr + off + 1), 0);
}

static inline size_t mem_indirect_zp(cpu *m, uint8_t addr)
{
  //    return mem_abs(m->mem[addr], m->mem[addr + 1], 0);
  return mem_abs(read_byte(m, addr), read_byte(m, addr + 1), 0);
}

// set arg MUST be 16 bits, not 8, so that add results can fit into set.
static inline void set_flag(cpu *m, uint8_t flag, uint16_t set)
{
  if (set)
  {
    m->sr |= flag;
  }
  else
  {
    m->sr &= ~flag;
  }
}

static inline uint8_t get_flag(cpu *m, uint8_t flag)
{
  return (m->sr & flag) > 0;
}

static inline uint8_t get_emu_flag(cpu *m, uint8_t flag)
{
  return (m->emu_flags & flag) > 0;
}

// set flags for the result of a computation. set_flags should be called on the
// result of any arithmetic operation.
static inline void set_flags(cpu *m, uint8_t val)
{
  set_flag(m, FLAG_ZERO, !val);
  set_flag(m, FLAG_NEGATIVE, val & 0x80);
}

static inline uint8_t bcd(uint8_t val)
{
  // bcd is "binary coded decimal"; it treats the upper nibble and lower
  // nibble of a byte each as a decimal digit, so 01011000 -> 0101 1000 -> 58.
  // in other words, treat hex output as decimal output, so 0x58 is treated as
  // 58. this is dumb and adds a bunch of branching to opcode interpretation
  // that I Do Not Like.
  return 10 * (val >> 4) + (0x0F & val);
}

// convert hex back to binary packed decimal
//  static uint8_t hexTo_bdc(uint8_t val)
//  {
//    uint8_t y = 0;
//    if (val / 10 < 10)
//    {
//      y = (val / 10) << 4;
//    }
//    y = (y << 4)| (val % 10);
//    return (y);
//  }

static uint8_t convert2BCD(uint8_t hexData)
{
  uint8_t bcdHI = hexData / 10;
  while (bcdHI >= 10)
  {
    bcdHI -= 10;
  }
  uint8_t bcdLO = hexData % 10;
  uint8_t bcdData = (bcdHI << 4) + bcdLO;
  return bcdData;
}

static inline void add(cpu *m, uint16_t r1)
{
  // committing a cardinal sin for my sanity's sake. callers should initialize
  // r1 to the argument to the add.
  if (get_flag(m, FLAG_DECIMAL))
  {
    r1 = bcd(r1) + bcd(m->ac) + get_flag(m, FLAG_CARRY);
    set_flag(m, FLAG_CARRY, r1 > 99);
    r1 = convert2BCD(r1);
  }
  else
  {
    r1 += m->ac + get_flag(m, FLAG_CARRY);
    set_flag(m, FLAG_CARRY, r1 & 0xFF00);
  }
  set_flag(m, FLAG_OVERFLOW, (m->ac & 0x80) != (r1 & 0x80));
  set_flag(m, FLAG_ZERO, r1 == 0);
  set_flag(m, FLAG_NEGATIVE, r1 & 0x80);
  m->ac = r1;
}

static inline void sub(cpu *m, uint16_t r1)
{
  if (get_flag(m, FLAG_DECIMAL))
  {
    r1 = bcd(m->ac) - bcd(r1) - !get_flag(m, FLAG_CARRY);
    set_flag(m, FLAG_OVERFLOW, r1 > 99 || r1 < 0);
    r1 = convert2BCD(r1);
  }
  else
  {
    r1 = m->ac - r1 - !get_flag(m, FLAG_CARRY);
    set_flag(m, FLAG_OVERFLOW, 0xFF00 & r1);
  }
  set_flag(m, FLAG_CARRY, !(r1 & 0x8000));
  set_flag(m, FLAG_NEGATIVE, r1 & 0x80);
  set_flag(m, FLAG_ZERO, r1 == 0);
  m->ac = r1;
}

static inline void cmp(cpu *m, uint8_t mem, uint8_t reg)
{
  set_flag(m, FLAG_CARRY, reg >= mem);
  set_flag(m, FLAG_ZERO, reg == mem);
  set_flag(m, FLAG_NEGATIVE, 0x80 & (reg - mem));
}

// called at the start of processing an instruction to reset instruction-local
// emulator state
static inline void reset_emu_flags(cpu *m)
{
  m->emu_flags = 0x00;
}

// mark a memory address as dirty
static inline void mark_dirty(cpu *m, uint16_t address)
{
  if (isValidWrite(address))
  {
    m->emu_flags |= EMU_FLAG_DIRTY;
    m->dirty_mem_addr = address;
  }
}

#endif
