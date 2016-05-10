import sys
class mymain:
    def __init__(self):
        pass

    def main(self):
        a = None
        a = self.gcd(3, 15)
        sys.stdout.write (str(a))
        return 0
        pass

    def gcd(self,a,b):
        while ((a) != (b)):
            if ((a) > (b)):
                a = (a) - (b)
            else:
                b = (b) - (a)
        return a
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

