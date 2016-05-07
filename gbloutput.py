class UserMain:
    def __init__(self):
        pass
    def main(self):
        mygame = Gobang()
        MapS = [ None ] * 2

        Map[0]=15
        Map[1]=15
        GridNum = (Map[0]) * (Map[1])
        InputPlayerNumber = 2
        InputPlayerId = [ None ] * PlayerNumber

        InputPlayerId[0]=0
        InputPlayerId[1]=1
        InputPlayerName[PlayerNumber]
        InputPlayerName[0]="Cuidiao"
        InputPlayerName[1]="Xicao"
        InputwithAI = True
        mygame.initialize(MapS, PlayerNum, InputPlayerID, InputPlayerName, InputwithAI)
        while (not (mygame.win())):
            print("This is the turn of player")
            print(mygame.NextPlayerID)
            InputPosition = [ None ] * 2

            if (InputwithAI):
                rposition = None

                rposition = GobangAI.returnposition()
                InputPosition[0]=(rposition) / (Mapsize[0])
                InputPosition[1]=(rposition) % (Mapsize[0])
            else:
                legal = False
                while (not (legal)):
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
        position = [ None ] * 2

        i = None

        j = None

        i = 0
        while ((i) < (Mapsize[0])):
            j = 0
            while ((j) < (Mapsize[1])):
                if ((SpriteOwnerId) == ( - (1))):
                    position[0]=i
                    position[1]=j
                j = (j) + (1)
            i = (i) + (1)
        return ((position[0]) * (Mapsize[0])) + (position[1])
        pass
class Gobang:
    def __init__(self):
        self.withAI = None
        self.NextSpriteID = None
        self.NextPlayerID = None
        self.FormerPosition = [ None ] * 2
        self.FormerId = None
        self.SpriteOwnerId = [ None ] * self.GridNum
        self.SpriteId = [ None ] * self.GridNum
        self.PlayerName = [ None ] * self.PlayerNumber
        self.PlayerId = [ None ] * self.PlayerNumber
        self.PlayerNumber = None
        self.GridNum = None
        self.MapSize = [ None ] * 2
        pass
    def update(self,InputPosition):
        self.SpriteId[((InputPosition[0]) * (Mapsize[0])) + (InputPosition[1])]=self.NextSpriteID
        self.SpriteOwnerId[((InputPosition[0]) * (Mapsize[0])) + (InputPosition[1])]=self.NextPlayerID
        self.FormerId = self.NextPlayerID
        self.FormerPosition[0]=InputPosition[0]
        self.FormerPosition[1]=InputPosition[1]
        self.NextSpriteID = (self.NextSpriteID) + (1)
        self.NextPlayerID = (self.NextPlayerID) + (1)
        if ((self.NextPlayerID) == (self.PlayerNumber)):
            self.NextPlayerID = 0
        pass
    def isLegal(self,position):
        if (not (((position[0]) >= (0)) and ((position[0]) < (((self.MapSize[0]) and ((position[1]) >= (0))) and ((position[1]) < (self.MapSize[1])))))):
            return False
        if ((mygame.SpriteOwnerId[((position[0]) * (Mapsize[0])) + (position[1])]) == ( - (1))):
            return True
        else:
            return False
        pass
    def win(self):
        PlayerSprite = self.FormerId
        position = [ None ] * 2

        position[0]=self.FormerPosition[0]
        position[1]=self.FormerPosition[1]
        if (((position[0]) - (4)) > (0)):
            left = (position[0]) - (4)
        else:
            left = 0
        if (((position[0]) + (4)) > ((Mapsize[0]) - (1))):
            right = (Mapsize[0]) - (1)
        else:
            right = (position[0]) + (4)
        if (((position[1]) - (4)) > (0)):
            up = (position[1]) - (4)
        else:
            up = 0
        if (((position[1]) + (4)) > ((Mapsize[1]) - (1))):
            down = (Mapsize[1]) - (1)
        else:
            down = (position[1]) + (4)
        i = None

        j = None

        count = None

        PreSprite =  - (1)
        count = 0
        j = left
        while ((j) <= (right)):
            curSprite = self.SpriteOwnerId[((position[0]) * (Mapsize[0])) + (j)]
            if ((curSprite) == (PlayerSprite)):
                if ((PreSprite) != (PlayerSprite)):
                    count = 1
                else:
                    count = (count) + (1)
                if ((count) == (5)):
                    return True
            else:
                count = 0
            PreSprite = curSprite
            j = (j) + (1)
        PreSprite =  - (1)
        count = 0
        i = up
        while ((i) <= (down)):
            curSprite = self.SpriteOwnerId[((i) * (Mapsize[0])) + (position[1])]
            if ((curSprite) == (PlayerSprite)):
                if ((PreSprite) != (PlayerSprite)):
                    count = 1
                else:
                    count = (count) + (1)
                if ((count) == (5)):
                    return True
            else:
                count = 0
            PreSprite = curSprite
            i = (i) + (1)
        PreSprite =  - (1)
        count = 0
        leftup = [ None ] * 2

        leftupDistance = None

        leftupDistance = 4
        if ((position[0]) < (4)):
            leftupDistance = position[0]
        if ((position[1]) < (4)):
            leftupDistance = position[1]
        leftup[0]=(position[0]) - (leftupDistance)
        leftup[1]=(position[1]) - (leftupDistance)
        rightdown = [ None ] * 2

        rightdownDistance = None

        rightdownDistance = 4
        if ((((self.MapSize[0]) - (1)) - (position[0])) < (4)):
            rightdownDistance = ((self.MapSize[0]) - (1)) - (position[0])
        if ((((self.MapSize[1]) - (1)) - (position[1])) < (4)):
            rightdownDistance = ((self.MapSize[1]) - (1)) - (position[1])
        rightdown[0]=(position[0]) + (rightdownDistance)
        rightdown[1]=(position[1]) + (rightdownDistance)
        curposition = [ None ] * 2

        i = 0
        while ((i) <= ((rightdown[0]) - (leftup[0]))):
            curposition[0]=(leftup[0]) + (i)
            curposition[1]=(leftup[1]) + (i)
            curSprite = self.SpriteOwnerId[((curposition[0]) * (Mapsize[0])) + (curposition[1])]
            if ((curSprite) == (PlayerSprite)):
                if ((PreSprite) != (PlayerSprite)):
                    count = 1
                else:
                    count = (count) + (1)
                if ((count) == (5)):
                    return True
            else:
                count = 0
            PreSprite = curSprite
            i = (i) + (1)
        PreSprite =  - (1)
        count = 0
        leftdown = [ None ] * 2

        leftdownDistance = 4
        if ((position[0]) < (4)):
            leftdownDistance = position[0]
        if ((((self.MapSize[1]) - (1)) - (position[1])) < (4)):
            leftdownDistance = ((self.MapSize[1]) - (1)) - (position[1])
        leftdown[0]=(position[0]) - (leftdownDistance)
        leftdown[1]=(position[1]) + (leftdownDistance)
        rightup = [ None ] * 2

        rightupDistance = 4
        if ((((self.MapSize[0]) - (1)) - (position[0])) < (4)):
            rightupDistance = ((self.MapSize[0]) - (1)) - (position[0])
        if ((position[1]) < (4)):
            rightupDistance = position[1]
        rightup[0]=(position[0]) + (rightupDistance)
        rightup[1]=(position[1]) - (rightupDistance)
        curposition = [ None ] * 2

        i = 0
        while ((i) <= ((rightup[0]) - (leftdown[0]))):
            curposition[0]=(leftdown[0]) + (i)
            curposition[1]=(leftdown[1]) - (i)
            curSprite = self.SpriteOwnerId[((curposition[0]) * (Mapsize[0])) + (curposition[1])]
            if ((curSprite) == (PlayerSprite)):
                if ((PreSprite) != (PlayerSprite)):
                    count = 1
                else:
                    count = (count) + (1)
                if ((count) == (5)):
                    return True
            else:
                count = 0
            PreSprite = curSprite
            i = (i) + (1)
        return False
        pass
    def initialize(self,MapS,InputPlayerNum,InputPlayerID,InputPlayerName,InputwithAI):
        self.MapSize[0]=MapS[0]
        self.MapSize[1]=MapS[1]
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
                self.SpriteId[((i) * (Mapsize[0])) + (j)]= - (1)
                self.SpriteOwnerId[((i) * (Mapsize[0])) + (j)]= - (1)
                j = (j) + (1)
            i = (i) + (1)
        self.FormerId =  - (1)
        self.FormerPosition[0]= - (1)
        self.FormerPosition[1]= - (1)
        self.NextPlayerID = 0
        self.NextSpriteID = 0
        pass
real_main = UserMain()
real_main.main()
