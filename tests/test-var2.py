import sys
class mymain:
    def __init__(self):
        self.a = None
        pass

    def main(self):
        self.foo(73)
        print (self.a)
        return 0
        pass

    def foo(self,c):
        self.a = (c) + (42)
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

