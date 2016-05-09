class myMain extends Main{
int main()
{
  int intArray[10];
  intArray[11] = false; #Fail: array index out of range
  return 0;
}
}