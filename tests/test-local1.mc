void foo(bool i)
{
  int i; #Should hide the formal i

  i = 42;
  println(i + i);
}

int main()
{
  foo(true);
  return 0;
}
