import sys
class mymain:
    def __init__(self):
        pass

    def main(self):
        print (self.gcd(14, 21))
        print (self.gcd(8, 36))
        print (self.gcd(99, 121))
        return 0
        pass

    def gcd(self,a,b):
        while ((a) <= (b)):
            if ((a) > (b)):
                a = (a) - (b)
            else:
                b = (b) - (a)
        return a
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

