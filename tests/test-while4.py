import sys
class mymain:
    def __init__(self):
        pass

    def main(self):
        print (self.foo(7))
        return 0
        pass

    def foo(self,a):
        j = None
        j = 0
        while ((a) > (0)):
            if ((a) == (5)):
                a = (a) - (1)
                continue
            j = (j) + (2)
            a = (a) - (1)
        return j
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

