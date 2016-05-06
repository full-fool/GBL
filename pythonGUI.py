import Tkinter as tk


class GameBoard(tk.Frame):
    def __init__(self, parent, rows=8, columns=8, size=32, offset = 100, players = 2, colors=["black", "white"], color1 = "blue", color2 = "white"):
        '''size is the size of a square, in pixels'''
        
        self.rows = rows
        self.columns = columns
        self.size = size
        self.colors = colors
        self.color1 = color1
        self.color2 = color2
        self.pieces = {}
        self.avatars = {}
        self.turns = 0
        self.numPlayers = players
        canvas_width = columns * size + offset
        canvas_height = rows * size
        
        tk.Frame.__init__(self, parent)
        self.canvas = tk.Canvas(self, borderwidth=0, highlightthickness=0,
                                width=canvas_width, height=canvas_height, background="bisque")
        self.canvas.pack(side="top", fill="both", expand=True, padx=2, pady=2)
                                
        # this binding will cause a refresh if the user interactively
        # changes the window size
        self.canvas.bind("<Configure>", self.refresh)
        self.canvas.bind("<Button-1>", self.callback)

    def callback(self, event):
        self.addpiece("Player"+str(len(self.pieces.keys())), event.y/self.size, event.x/self.size)
        self.turns += 1
        if self.turns >= self.numPlayers:
            self.turns = 0
        print "clicked at", event.x, event.y

    def addpiece(self, name, row=0, column=0):
        '''Add a piece to the playing board'''
        self.pieces[name] = (row, column)
        x0 = (column * self.size) + int(self.size/2)
        y0 = (row * self.size) + int(self.size/2)
        self.canvas.create_circle(x0, y0, self.size/3, fill=self.colors[self.turns])
        self.turns += 1
        if self.turns >= self.numPlayers:
            self.turns = 0
        self.canvas.coords(name, x0, y0)

    def addavatar(self, name, row=0, column=0):
        '''Add a piece to the playing board'''
        column = 9;
        self.avatars[name] = (row, column)
        x0 = (column * self.size) + int(self.size/2)
        y0 = (row * self.size) + int(self.size/2)
        self.canvas.create_circle(x0, y0, self.size*2/3, fill=self.colors[self.turns])
        self.turns += 1
        if self.turns >= self.numPlayers:
            self.turns = 0
        self.canvas.coords(name, x0, y0)
        self.canvas.create_text((self.rows+1.5)*self.size, 3*self.size, text="Player 1")
    
    def refresh(self, event):
        '''Redraw the board, possibly in response to window being resized'''
        xsize = int((event.width-1) / self.columns)
        ysize = int((event.height-1) / self.rows)
        self.size = min(xsize, ysize)
        self.canvas.delete("all")
        color = self.color2
        for row in range(self.rows):
            color = self.color1 if color == self.color2 else self.color2
            for col in range(self.columns):
                x1 = (col * self.size)
                y1 = (row * self.size)
                x2 = x1 + self.size
                y2 = y1 + self.size
                self.canvas.create_rectangle(x1, y1, x2, y2, outline="black", fill=color, tags="square")
                color = self.color1 if color == self.color2 else self.color2
        for name in self.pieces:
            self.addpiece(name, self.pieces[name][0], self.pieces[name][1])
        for name in self.avatars:
            self.addavatar(name, self.avatars[name][0], self.avatars[name][1])
        text2 = self.canvas.create_text((self.rows+1.5)*self.size, 7*self.size, text="Player 2")
        
        self.canvas.tag_raise("piece")
        self.canvas.tag_lower("square")

def _create_circle(self, x, y, r, **kwargs):
    return self.create_oval(x-r, y-r, x+r, y+r, **kwargs)

if __name__ == "__main__":
    root = tk.Tk()
    tk.Canvas.create_circle = _create_circle
    board = GameBoard(root)
    board.pack(side="top", fill="both", expand="true", padx=4, pady=4)
    for i in range(board.numPlayers):
        board.addavatar("player"+str(i)+"Avatar", i, board.numPlayers)
        board.addavatar("player2Avatar", 5, 9)
    
    root.mainloop()