int main()
{
  array<int> intArray[10];
  array<string> stringArray[10];
  intArray = stringArray; #Fail: assigning a array<string> to a array<int>
  return 0;
}
