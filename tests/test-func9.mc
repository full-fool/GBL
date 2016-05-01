void foo(int a)
{
  println(a + 3);
}

void foo(int a, int b)
{
  println(a + b);
}

int main()
{
  foo(40);
  foo(30, 40);
  return 0;
}
