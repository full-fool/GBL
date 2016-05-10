import sys
class mymain:
    def __init__(self):
        pass

    def main(self):
        stringArray = [ None ] * 5
        stringArray[1]="hello"
        stringArray[2]="world"
        i = None
        i = 0
        while ((i) < (5)):
            print (stringArray[i])
            i = (i) + (1)
        return 0
        pass


if __name__ == "__main__":
    _main = mymain()
    _main.main()

