### gloabl variables including array, initialization



class Gobang extends Game
{
    #variables:
    #Map:
    int MapSize[2];
    int GridNum;  #GridNum = Mapsize[0] * Mapsize[1]
    #Player:
    int PlayerNumber;
    int PlayerId[PlayerNumber];
    string PlayerName[PlayerNumber];
    #Sprite:
    int SpriteId[GridNum];
    int SpriteOwnerId[GridNum];
    #LastMove:
    int FormerId; #the ID of former player
    int FormerPosition[2];
    #Next Turn:
    int NextPlayerID;
    int NextSpriteID;
    #AI?
    bool withAI;




    #functions:
    void initialize(int MapS, int InputPlayerNum, int InputPlayerID, string InputPlayerName, bool InputwithAI)
    {
        MapSize[0] = MapS[0]; 
        MapSize[1] = MapS[1];
        PlayerNumber = InputPlayerNum;
        withAI = InputwithAI;
        int i;
        for(i = 0; i < PlayerNumber; i = i + 1)
        {
            PlayerId[i] = InputPlayerID[i];
            PlayerName[i] = InputPlayerName[i];
        }
        int i;
        int j;
        for(i = 0; i < MapSize[0]; i = i + 1)
        {
            for(j = 0; j < MapSize[1]; j = j + 1)
            {
                SpriteId[i * Mapsize[0] + j] = -1;
                SpriteOwnerId[i * Mapsize[0] + j] = -1;
            }
        }
        FormerId = -1;
        FormerPosition[0] = -1;
        FormerPosition[1] = -1;
        NextPlayerID = 0;
        NextSpriteID = 0;
    }

    bool win()
    {
      #string PlayerSprite = PlayerSpriteName[FormerId];
      int PlayerSprite = FormerId;
      int position[2];
      position[0] = FormerPosition[0];
      position[1] = FormerPosition[1];
      if((position[0] - 4) > 0) left = position[0] - 4;
      else left = 0;
      if((position[0] + 4) > (Mapsize[0] - 1)) right = Mapsize[0] - 1;
      else right = position[0] + 4;
      if((position[1] - 4) > 0) up = position[1] - 4;
      else up =0;
      if((position[1] + 4)>(Mapsize[1] - 1))down = Mapsize[1] - 1;
      else down = position[1] + 4;
      int i;
      int j;
      int count;

      #check row
      int PreSprite = -1;
      count = 0;
      
      for(j = left; j <= right; j = j + 1)
      {
        int curSprite = SpriteOwnerId[position[0] * Mapsize[0] + j];
        #string curSprite = Text@SpriteList[position[0]][j];
        if(curSprite == PlayerSprite)
        {
          if(PreSprite != PlayerSprite)
          {
            count = 1;
          }
          else count = count + 1;
          if(count == 5)
            return true;
        }
        else count = 0;

        PreSprite = curSprite;
      }

      #check column
      PreSprite = -1;
      count = 0;
      for(i = up; i <= down; i = i + 1)
      {
        int curSprite = SpriteOwnerId[i * Mapsize[0] + position[1]];
        if(curSprite == PlayerSprite)
        {
          if(PreSprite != PlayerSprite)
          {
            count = 1;
          }
          else count = count + 1;
          if(count == 5)
            return true;
        }
        else count = 0;

        PreSprite = curSprite;
      }

      #check diagonal left-up to right-down
      PreSprite = -1;
      count = 0;
      int leftup[2];
      int leftupDistance;
      leftupDistance = 4;
      if(position[0] < 4) leftupDistance = position[0];
      if(position[1] < 4) leftupDistance = position[1];
      leftup[0] = position[0] - leftupDistance;
      leftup[1] = position[1] - leftupDistance;

      int rightdown[2];
      int rightdownDistance;
      rightdownDistance = 4;
      if((MapSize[0] - 1 - position[0]) < 4) rightdownDistance = MapSize[0] - 1 - position[0];
      if((MapSize[1] - 1 - position[1]) < 4) rightdownDistance = MapSize[1] - 1 - position[1];
      rightdown[0] = position[0] + rightdownDistance;
      rightdown[1] = position[1] + rightdownDistance;

      int curposition[2];
      
      for(i = 0; i <= (rightdown[0] - leftup[0]); i = i + 1)
      {
        curposition[0] = leftup[0] + i;
        curposition[1] = leftup[1] + i;
        int curSprite = SpriteOwnerId[curposition[0] * Mapsize[0] + curposition[1]];
        if(curSprite == PlayerSprite)
        {
          if(PreSprite != PlayerSprite)
          {
            count = 1;
          }
          else count = count + 1;
          if(count == 5)
            return true;
        }
        else count = 0;

        PreSprite = curSprite;
      }

      #check diagonal left-down to right-up
      PreSprite = -1;
      count = 0;
      int leftdown[2];
      int leftdownDistance = 4;
      if(position[0] < 4) leftdownDistance = position[0];
      if((MapSize[1] - 1 - position[1]) < 4) leftdownDistance = MapSize[1] - 1 - position[1];
      leftdown[0] = position[0] - leftdownDistance;
      leftdown[1] = position[1] + leftdownDistance;

      int rightup[2];
      int rightupDistance = 4;
      if((MapSize[0] - 1 - position[0]) < 4) rightupDistance = MapSize[0] - 1 - position[0];
      if((position[1]) < 4) rightupDistance = position[1];
      rightup[0] = position[0] + rightupDistance;
      rightup[1] = position[1] - rightupDistance;

      int curposition[2];
      
      for(i = 0; i <= (rightup[0] - leftdown[0]); i = i + 1)
      {
        curposition[0] = leftdown[0] + i;
        curposition[1] = leftdown[1] - i;
        int curSprite = SpriteOwnerId[curposition[0] * Mapsize[0] + curposition[1]];
        if(curSprite == PlayerSprite)
        {
          if(PreSprite != PlayerSprite)
          {
            count = 1;
          }
          else count = count + 1;
          if(count == 5)
            return true;
        }
        else count = 0;
        
        PreSprite = curSprite;
      }
      
      return false;
    }
    
    #check if the move is legal
    bool isLegal(int position)
    {
      if(not (position[0]>=0 and position[0]<MapSize[0] and position[1]>=0 and position[1]<MapSize[1]))
        return false;
      if(SpriteOwnerId[position[0] * Mapsize[0] + position[1]]@mygame == -1)
        return true;
      else return false;
    }
    
    void update(int InputPosition)
    {
        SpriteId[InputPosition[0] * Mapsize[0] + InputPosition[1]] = NextSpriteID;
        SpriteOwnerId[InputPosition[0] * Mapsize[0] + InputPosition[1]] = NextPlayerID;

        FormerId = NextPlayerID;
        FormerPosition[0] = InputPosition[0];
        FormerPosition[1] = InputPosition[1];
        NextSpriteID = NextSpriteID + 1;
        NextPlayerID = NextPlayerID + 1;
        if(NextPlayerID == PlayerNumber)
            NextPlayerID = 0;
    }
    
    #void printGame();
    #for(int i = 0; i < MapSize[0]; i = i + 1)
    #{
    #  for(int j = 0; j < MapSize[1]; j = j + 1)
    #  {
    #    print(Text@SpriteList[i][j]@mygame);
    #  }
    #  print("\n");
    #}
}

class GobangAI extends AI{
  int returnposition()
  {
    int position[2];
    int i;
    int j;
    for(i = 0; i < Mapsize[0]; i = i + 1)
    {
      for(j = 0; j < Mapsize[1]; j = j + 1)
      {
        if(SpriteOwnerId == -1)
        {
          position[0] = i;
          position[1] = j;
        }
      }
    }
    return position[0]* Mapsize[0] + position[1];
  }
}

#assume the input stream is stdin>>...
class UserMain extends Main{
  void main()
  {
      Gobang mygame;
      int MapS[2];
      Map[0] = 15;
      Map[1] = 15;
      int GridNum = Map[0] * Map[1];
      int InputPlayerNumber = 2;
      int InputPlayerId[PlayerNumber];
      InputPlayerId[0] = 0;
      InputPlayerId[1] = 1;
      InputPlayerName[PlayerNumber];
      InputPlayerName[0] = "Cuidiao";
      InputPlayerName[1] = "Xicao";
      InputwithAI = true;

      initialize(MapS, PlayerNum, InputPlayerID, InputPlayerName, InputwithAI)@mygame;
      #printGame()@mygame;

      
      while(not win()@mygame)
      {
          print("This is the turn of player");
          print(NextPlayerID@mygame);
          
          #input position
          int InputPosition[2];

          if(InputwithAI)
          {
            int rposition;
            rposition = returnposition()@GobangAI;
            InputPosition[0] = rposition / Mapsize[0];
            InputPosition[1] = rposition % Mapsize[0];
          }
          else
          {
            bool legal = false;
            while(not legal)
            {
              #stdin>>InputPosition[0];
              #stdin>>InputPosition[1];
              legal = isLegal(InputPosition)@mygame;
            }
          }
          
          #update status
          update(InputPosition)@mygame;

          #print map
          #printGame()@mygame;
      }
      #print
      int winner = NextPlayerID@mygame - 1;
      print("Winner is: ");
      print(winner);
  }
}