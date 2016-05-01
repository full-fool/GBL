int cond(bool b)
{
  int x;
  if (b)
    x = 42;
  else
    x = 17;
  return x;
}

int main()
{
 println(cond(true));
 println(cond(false));
 return 0;
}
