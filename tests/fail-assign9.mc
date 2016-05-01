int main()
{
  array<int> intArray[10];
  array<string> stringArray[10];
  intArray[1] = stringArray[1]; #Fail: assigning a string to a int
  return 0;
}
