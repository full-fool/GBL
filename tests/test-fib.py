import sys
class mymain:
    def __init__(self):
        pass

    def main(self):
        print (self.fib(0))
        print (self.fib(1))
        print (self.fib(2))
        print (self.fib(3))
        print (self.fib(4))
        print (self.fib(5))
        return 0
        pass

    def fib(self,x):
        if ((x) < (2)):
            return 1
        return (self.fib((x) - (1))) + (self.fib((x) - (2)))
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

