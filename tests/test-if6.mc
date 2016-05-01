int cond(bool b, bool c, bool d)
{
  int x;
  if (b and c or d)
    x = 42;
  else
    x = 17;
  return x;
}

int main()
{
 println(cond(true, true, false));
 println(cond(false, false, false));
 return 0;
}
