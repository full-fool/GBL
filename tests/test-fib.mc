int fib(int x)
{
  if (x < 2) return 1;
  return fib(x-1) + fib(x-2);
}

int main()
{
  println(fib(0));
  println(fib(1));
  println(fib(2));
  println(fib(3));
  println(fib(4));
  println(fib(5));
  return 0;
}
