int a;
bool b;

void foo(int c, bool d)    
{
  int d;
  bool e;
  e is d; #Error: bool is int
}

int main()
{
  return 0;
}
