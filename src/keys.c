#include "keys.h"
#include <stdlib.h>
#include <stdio.h>

keys * new_keys() {
  keys *k = malloc(sizeof(keys));
  reset_keys(k);
  return k;
}

void destroy_keys(keys* k) 
{
  free(k);
}

void reset_keys(keys* k)
{
  k->sw1_reset = false;
  k->sw2_key = true;
  k->sw3_key = true;
  k->sw4_key = true;
  k->sw5_key = true;
  k->sw6_key = true;  
}

