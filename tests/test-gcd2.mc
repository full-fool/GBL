int gcd(int a, int b) {
  while (a neq b)
    if (a > b) a = a - b;
    else b = b - a;
  return a;
}

int main()
{
  println(gcd(14,21));
  println(gcd(8,36));
  println(gcd(99,121));
  return 0;
}
