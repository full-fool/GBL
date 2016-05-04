int gcd(int a, int b) {
  while (a != b) {
    if (a > b) a = a - b;
    else b = b - a;
  }
  return a;
}

int main()
{
  int a;

  a = gcd(3,15);
  int b;

  print("123");
  return 0;
}
