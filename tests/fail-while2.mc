int main()
{
  int i;

  while (true) {
    i = i + 1;
  }

  while (i > 0) {
    foo(); #foo undefined
  }

}
