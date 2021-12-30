



int main()
{
  char name[130] = "StudyTonight";  
  //char[100] * myString = "Test String in C Code on 65C02";
  int index = 0;
  char alpha = '0';
  while(1)
  {
    
    name[index++] = alpha;
    if(index >= sizeof(name))
    {
      index = 0;
      alpha++;
    }
  }


return (0); //  We should never get here!
}