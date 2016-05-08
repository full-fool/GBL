import Tkinter as tk


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