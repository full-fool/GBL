int main()
{
  int i;

  while (true) {
    i = i + 1;
  }
  continue; #Fail: Should in while or for loop
  while (false) { 
    i = i + 1;
  }

}
