#ifndef __6502_KEYS__
#define __6502_KEYS__

#include <stdint.h>
#include <stdbool.h>


//according to schematic 6502-schematic.png there are 6 switches in base build.
//one main cpu reset
//five inputs connected to 65C22 chip, these input are pulled high and go low when switch pressed 
typedef struct {
  bool sw1_reset;
  // key states
  bool sw2_key;
  bool sw3_key;
  bool sw4_key;
  bool sw5_key;
  bool sw6_key;
} keys;

keys* new_keys();

void destroy_keys(keys* k);

void reset_keys(keys* k);

#endif
