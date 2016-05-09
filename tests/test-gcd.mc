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
<<<<<<< HEAD

  a = gcd(3,15);
int c;
=======
  int b;
  a = gcd(3,15);

  print(a);
>>>>>>> 819307bbcff059cb5ab3fe0be01100242b9463c0
  return 0;
}
