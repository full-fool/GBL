int main()
{
  array<string> stringArray[5];
  stringArray[1]="hello";
  stringArray[2]="world";
  int i;
  for(i = 0; i < 5; i = i + 1){
    println(stringArray[i]);
  }
  return 0;
}
