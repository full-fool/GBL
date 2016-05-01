int a;
bool b;

void foo(int c, bool d)    
{
  int d;
  bool e;
  e = true or d; # Fail: illegal binary operator bool or int
}

int main()
{
  return 0;
}
