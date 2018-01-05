#include <stdio.h>
#define STDIN 0
void AFL_Check(){}
int cgc_strcmp(char* s1, char* s2)
{
  if (s1 == NULL)
  {
    if (s2 == NULL)
    {
      return (0);
    }
    else
    {
      return (-1);
    }
  }
  if (s2 == NULL)
  {
    return (1);
  }

  int i = 0;
  while (s1[i] != '\0')
  {
    if (s2[i] == '\0')
    {
      return (1);
    }
    if (s1[i] < s2[i])
    {
      return (-1);
    }
    else if (s1[i] > s2[i])
    {
      return (1);
    }
    AFL_Check();
    i++;
  }

  if (s2[i] == '\0')
  {

      *((int*)0) = 1;
    AFL_Check();
    return (0);
  }

  return (-1);
}
int main(){

    char s[256];

      int ret= read(STDIN,s,256);
      if(ret==0) return 1;
      s[ret-1] ='\0';
      cgc_strcmp(s,"4abcdef");
}
