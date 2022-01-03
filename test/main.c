

extern void __fastcall__ startMyTest (void);

int main () {


  startMyTest();
  while (1);
  
  return (0);                                     //  We should never get here!
}