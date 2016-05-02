int a;
bool b;

void foo(int c, bool d)    
{
  int d;
  bool e;
  e = not d; #Error: not int
}

int main()
{
  return 0;
}
