int foo(int a)
{
  int j;
  j = 0;
  while (a > 0) {
    if (a is 5) {
      a = a - 1;
      continue;
    }
    j = j + 2;
    a = a - 1;
  }
  return j;
}

int main()
{
  println(foo(7));
  return 0;
}
