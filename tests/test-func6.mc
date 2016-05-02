void foo() {}

int bar(int a, bool b, int c) { return a + c; }

int bar(int a, int b, int c) { return b + c; }

int main()
{
  println(bar(17, false, 25));
  println(bar(17, 16, 25));
  return 0;
}
