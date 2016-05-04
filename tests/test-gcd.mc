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
  int b;
  a = gcd(3,15);

  print(a);
  return 0;
}
