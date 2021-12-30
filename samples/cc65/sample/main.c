



int main()
{
  int *dataDirectionB =(int*) 0x6002;
  int *dataDirectionA =(int*) 0x6003;
  char name[130] = "StudyTonight";  
  int index = 0;
  char alpha = '0';
  *dataDirectionB = 0x00;
  *dataDirectionA = 0x00;
  while(1)
  {
    
    
    name[index++] = alpha;
    if(index >= sizeof(name))
    {
      index = 0;
      alpha++;
      *dataDirectionB += 1;
      *dataDirectionA += 1;
    }
  }


return (0); 
}