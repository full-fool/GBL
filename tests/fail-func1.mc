int foo() {}

int bar() {}

int baz() {}

void bar() {} #Error: duplicate function bar

int main()
{
  int m;
  return 0;
}
