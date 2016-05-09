    def initialize(self,MapS,InputPlayerNum,InputPlayerID,InputPlayerName,InputWithAI):
        self.MapSize[0]=MapS[0]
        self.MapSize[1]=MapS[1]
        self.GridNum = (self.MapSize[0]) * (self.MapSize[1])
        self.PlayerNumber = InputPlayerNum
        self.WithAI = InputWithAI
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