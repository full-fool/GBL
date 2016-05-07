import Tkinter as tk

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
        InputwithAI = True
        mygame.initialize(MapS, InputPlayerNumber, InputPlayerId, InputPlayerName, InputwithAI)
        gobanai = GobangAI()
        while (not (mygame.win())):
            print("This is the turn of player")
            print(mygame.NextPlayerID)
            InputPosition = [ None ] * 2

            if (InputwithAI):
                rposition = None

                rposition = gobanai.returnposition()
                InputPosition[0]=(rposition) / (mygame.MapSize[0])
                InputPosition[1]=(rposition) % (mygame.MapSize[0])
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
        return 0
        pass
class Gobang:
    def __init__(self):
        self.withAI = None
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
    def update(self,InputPosition):
        self.SpriteId[((InputPosition[0]) * (self.MapSize[0])) + (InputPosition[1])]=self.NextSpriteID
        self.SpriteOwnerId[((InputPosition[0]) * (self.MapSize[0])) + (InputPosition[1])]=self.NextPlayerID
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
        if ((mygame.SpriteOwnerId[((position[0]) * (self.MapSize[0])) + (position[1])]) == ( - (1))):
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
        if (((position[0]) + (4)) > ((self.MapSize[0]) - (1))):
            right = (self.MapSize[0]) - (1)
        else:
            right = (position[0]) + (4)
        if (((position[1]) - (4)) > (0)):
            up = (position[1]) - (4)
        else:
            up = 0
        if (((position[1]) + (4)) > ((self.MapSize[1]) - (1))):
            down = (self.MapSize[1]) - (1)
        else:
            down = (position[1]) + (4)
        i = None

        j = None

        count = None

        PreSprite =  - (1)
        count = 0
        j = left
        while ((j) <= (right)):
            curSprite = self.SpriteOwnerId[((position[0]) * (self.MapSize[0])) + (j)]
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
            curSprite = self.SpriteOwnerId[((i) * (self.MapSize[0])) + (position[1])]
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
            curSprite = self.SpriteOwnerId[((curposition[0]) * (self.MapSize[0])) + (curposition[1])]
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
            curSprite = self.SpriteOwnerId[((curposition[0]) * (self.MapSize[0])) + (curposition[1])]
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
real_main = UserMain()
real_main.main()











class GameBoard(tk.Frame):
    def __init__(self, parent, rows=18, columns=18, size=32, players = 6, colors=["black", "white","blue","yellow","grey","pink"], color = "bisque", ai=False):
        '''size is the size of a square, in pixels'''
        
        self.rows = rows
        self.columns = columns
        self.size = size
        self.colors = colors
        self.color = color # board color
        self.turns = 0 # current player
        self.pastPieces = [] #sprite list
        self.numPlayers = players
        self.enable = True # win or tie makes it false
        self.AI = ai
        canvas_width = (columns+5) * size
        canvas_height = rows * size
        
        tk.Frame.__init__(self, parent)
        self.canvas = tk.Canvas(self, borderwidth=0, highlightthickness=0,
                                width=canvas_width, height=canvas_height, background="bisque")
        self.canvas.pack(side="top", fill="both", expand=True, padx=2, pady=2)
                                
        # this binding will cause a refresh if the user interactively
        # changes the window size
        self.canvas.bind("<Configure>", self.refresh)
        self.canvas.bind("<Button-1>", self.callback)
        self.addavatar()

    #When mouse clicks
    def callback(self, event):
        if event.x < self.size*self.rows and event.y < self.size*self.columns and self.enable: # inside the board and hasn't finished the game yet
            if (event.y/self.size, event.x/self.size) not in self.pastPieces: #isLegal()

                # place sprite
                self.addpiece(str((event.y/self.size, event.x/self.size)), event.y/self.size, event.x/self.size)
                self.pastPieces.append((event.y/self.size, event.x/self.size))

                #if isWin():
                    #win()
                #if isTie():
                    #tie()
                #turn to next player
                self.turns += 1
                if self.turns >= self.numPlayers:
                    self.turns = 0
                
                self.addavatar()
        print "clicked at", event.x, event.y
    
    #update()
    def addpiece(self, name, row=0, column=0, curr=-1):
        '''Add a piece to the playing board'''
        x0 = (column * self.size) + int(self.size/2)
        y0 = (row * self.size) + int(self.size/2)
        if curr==-1:
            self.canvas.create_circle(x0, y0, self.size/3, fill=self.colors[self.turns])
        else:
            self.canvas.create_circle(x0, y0, self.size/3, fill=self.colors[curr])
        self.canvas.coords(name, x0, y0)

    #draw avatars
    def addavatar(self):
        '''Add a piece to the playing board'''
        self.canvas.delete("avatar")
        for i in range(self.numPlayers):
            name = "Player "+str(i)
            column = self.columns + 1.5
            row = self.rows * i / self.numPlayers + 1
            x0 = column * self.size
            y0 = row * self.size
            if i==self.turns:
                self.canvas.create_circle(x0, y0, self.size*3/4, fill=self.colors[i], tags="avatar")
            else:
                self.canvas.create_circle(x0, y0, self.size*2/3, fill=self.colors[i], tags="avatar")
            self.canvas.coords(name, x0, y0)
            self.canvas.create_text((self.columns+3.5)*self.size, row*self.size, text=name, tags="avatar")
    
    # redraw whole window
    def redraw(self):
        self.canvas.delete("all")
        for row in range(self.rows):
            for col in range(self.columns):
                x1 = (col * self.size)
                y1 = (row * self.size)
                x2 = x1 + self.size
                y2 = y1 + self.size
                self.canvas.create_rectangle(x1, y1, x2, y2, outline="black", fill=self.color, tags="square")
        i = 0
        for name in self.pastPieces:
            self.addpiece(str(name), name[0], name[1], curr=i)
            i += 1
            if i >= self.numPlayers:
                i = 0
        
        self.addavatar()
        self.canvas.tag_raise("piece")
        self.canvas.tag_lower("square")

    def refresh(self, event):
        '''Redraw the board, possibly in response to window being resized'''
        xsize = int((event.width-1) / self.columns)
        ysize = int((event.height-1) / self.rows)
        self.size = min(xsize, ysize)
        self.redraw()
        
    def clear(self):
        self.enable = True
        self.turns = 0
        self.pastPieces = set([])
        self.redraw()

    def win(self, i):
        self.enable = False
        winStr = "Player "+str(i) + " WIN"
        self.canvas.create_text(self.columns*self.size/2, self.rows*self.size/2, text = winStr, font=("Helvetica",32), fill = "red")

    def tie(self):
        self.enable = False
        self.canvas.create_text(self.columns*self.size/2, self.rows*self.size/2, text = "TIE", font=("Helvetica",50), fill = "red")

def _create_circle(self, x, y, r, **kwargs):
    return self.create_oval(x - r, y - r, x + r, y + r, **kwargs)

if __name__ == "__main__":
    root = tk.Tk()
    root.title("GBL")
    tk.Canvas.create_circle = _create_circle
    board = GameBoard(root)
    board.pack(side="top", fill="both", expand="true", padx=4, pady=4)
    
    root.mainloop()