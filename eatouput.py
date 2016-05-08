class UserMain:
    def __init__(self):
        pass
    def main(self):
        mygame = Gobang()
        MapS = [ None ] * 2
        MapS[0]=15
        MapS[1]=15
        GridNumber = (MapS[0]) * (MapS[1])
        InputPlayerNumber = 2
        InputPlayerId = [ None ] * InputPlayerNumber
        InputPlayerId[0]=0
        InputPlayerId[1]=1
        InputPlayerName = [ None ] * InputPlayerNumber
        InputPlayerName[0]="Cuidiao"
        InputPlayerName[1]="Xicao"
        InputWithAI = False
        mygame.initialize(MapS, InputPlayerNumber, InputPlayerId, InputPlayerName, InputWithAI)
        gobangai = GobangAI()
        while (not (mygame.win())):
            print("This is the turn of player")
            print(mygame.NextPlayerID)
            InputPosition = [ None ] * 2
            if ((InputWithAI) and ((mygame.NextPlayerID) != (0))):
                rposition = None
                rposition = gobanai.returnposition()
                InputPosition[0]=(rposition) / (mygame.MapSize[0])
                InputPosition[1]=(rposition) % (mygame.MapSize[0])
            else:
                legal = False
                while (not (legal)):
                    InputPosition[0]=input()
                    InputPosition[1]=input()
                    legal = mygame.isLegal(InputPosition)
            mygame.update(InputPosition)
        winner = (mygame.NextPlayerID) - (1)
        print("Winner is: ")
        print(winner)
        pass
class GobangAI:
    def __init__(self):
        pass
    def returnposition(self):
        r = [ None ] * 2
        r[0]=0
        r[1]=0
        return r
        pass
class Gobang:
    def __init__(self):
        self.WithAI = None
        self.NextSpriteID = None
        self.NextPlayerID = None
        self.FormerPosition = [ None ] * 2
        self.FormerId = None
        self.SpriteOwnerId = [ None ] * 1000
        self.SpriteId = [ None ] * 1000
        self.PlayerName = [ None ] * 10
        self.PlayerId = [ None ] * 10
        self.PlayerNumber = None
        self.GridNum = None
        self.MapSize = [ None ] * 2
        pass
    def initialize(self,MapS,InputPlayerNum,InputPlayerID,InputPlayerName,InputwithAI):
        self.MapSize[0]=MapS[0]
        self.MapSize[1]=MapS[1]
        self.GridNum = (self.MapSize[0]) * (self.MapSize[1])
        self.PlayerNumber = InputPlayerNum
        self.withAI = InputwithAI
        i = None

        i = 0
        while ((i) < (self.PlayerNumber)):
            self.PlayerId[i]=InputPlayerID[i]
            self.PlayerName[i]=InputPlayerName[i]
            i = (i) + (1)
        i = None

        j = None

        i = 0
        while ((i) < (self.MapSize[0])):
            j = 0
            while ((j) < (self.MapSize[1])):
                self.SpriteId[((i) * (self.MapSize[0])) + (j)]= - (1)
                self.SpriteOwnerId[((i) * (self.MapSize[0])) + (j)]= - (1)
                j = (j) + (1)
            i = (i) + (1)
        self.FormerId =  - (1)
        self.FormerPosition[0]= - (1)
        self.FormerPosition[1]= - (1)
        self.NextPlayerID = 0
        self.NextSpriteID = 0
        pass
    def update(self,InputPosition):
        CurSpriteID = None
        CurPlayerID = self.NextPlayerID
        self.SpriteId[((InputPosition[0]) * (self.MapSize[0])) + (InputPosition[1])]=self.NextSpriteID
        self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + (InputPosition[1])]=self.NextPlayerID
        self.FormerId = self.NextPlayerID
        self.FormerPosition[0]=InputPosition[0]
        self.FormerPosition[1]=InputPosition[1]
        self.NextSpriteID = (self.NextSpriteID) + (1)
        self.NextPlayerID = (self.NextPlayerID) + (1)
        if ((self.NextPlayerID) == (self.PlayerNumber)):
            self.NextPlayerID = 0
        a = [ None ] * 8
        t = None
        curr = 0
        t = 0
        while ((t) < (8)):
            a[t]= - (1)
            t = (t) + (1)
        if ((((InputPosition[0]) >= (2)) and ((self.SpriteOwnerId[(((InputPosition[0]) - (2)) * (self.MapSize[0])) + (InputPosition[1])]) == (CurPlayerID))) and ((self.SpriteOwnerId[(((InputPosition[0]) - (1)) * (self.MapSize[0])) + (InputPosition[1])]) == (self.NextPlayerID))):
            a[curr]=(InputPosition[0]) - (2)
            a[(curr) + (1)]=InputPosition[1]
            curr = (curr) + (2)
        if ((((InputPosition[0]) <= ((self.MapSize[0]) - (3))) and ((self.SpriteOwnerId[(((InputPosition[0]) + (2)) * (self.MapSize[0])) + (InputPosition[1])]) == (CurPlayerID))) and ((self.SpriteOwnerId[(((InputPosition[0]) + (1)) * (self.MapSize[0])) + (InputPosition[1])]) == (self.NextPlayerID))):
            a[curr]=(InputPosition[0]) + (2)
            a[(curr) + (1)]=InputPosition[1]
            curr = (curr) + (2)
        if ((((InputPosition[1]) >= (2)) and ((self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + ((InputPosition[1]) - (2))]) == (CurPlayerID))) and ((self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + ((InputPosition[1]) - (2))]) == (self.NextPlayerID))):
            a[curr]=InputPosition[0]
            a[(curr) + (1)]=(InputPosition[1]) - (2)
            curr = (curr) + (2)
        if ((((InputPosition[1]) <= ((self.MapSize[1]) - (3))) and ((self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + ((InputPosition[1]) + (2))]) == (CurPlayerID))) and ((self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + ((InputPosition[1]) + (2))]) == (self.NextPlayerID))):
            a[curr]=InputPosition[0]
            a[(curr) + (1)]=(InputPosition[1]) + (2)
            curr = (curr) + (2)
        return a
        pass
    def isLegal(self,position):
        if (not ((((position[0]) >= (0)) and ((position[0]) < (self.MapSize[0]))) and (((position[1]) >= (0)) and ((position[1]) < (self.MapSize[1]))))):
            return False
        if ((self.SpriteOwnerId[((position[0]) * (self.MapSize[0])) + (position[1])]) == ( - (1))):
            return True
        else:
            return False
        pass
    def win(self):
        return  - (1)
        pass
real_main = UserMain()
real_main.main()
