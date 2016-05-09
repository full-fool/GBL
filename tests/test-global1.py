import sys
class mymain:
    def __init__(self):
        self.c = None
        self.a = None
        pass

    def main(self):
        self.a = 42
        self.c = 21
        self.printa()
        self.printc()
        self.incab()
        self.printa()
        self.printc()
        return 0
        pass

    def incab(self):
        self.a = (self.a) + (1)
        self.c = (self.c) + (1)
        pass

    def printc(self):
        print (self.c)
        pass

    def printa(self):
        print (self.a)
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

