int cond(int a, int b)
{
  int x;
  if (a is b)
    x = 42;
  elif (a > b)
    x = 17;
  else
    x = 15;
  return x;
}

int main()
{
 println(cond(3, 15));
 println(cond(15, 15));
 return 0;
}
