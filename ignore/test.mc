### gloabl variables including array, initialization



class Gobang extends Game
{
    bool win()
    {
      #string PlayerSprite = PlayerSpriteName[FormerId];
      int PlayerSprite = FormerId;
      int position[2];
      position[0] = FormerPosition[0];
      position[1] = FormerPosition[1];
      int left = max(position[0] - 4, 0);
      int right = min(position[0] + 4, Mapsize[0] - 1);
      int up = max(position[1] - 4, 0);
      int down = min(position[1] + 4, Mapsize[1] - 1);
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

      PreSprite = -1;
      count = 0;
      int leftup[2];
      int leftupDistance = min(4, position[0], position[1])
      leftup[0] = position[0] - leftupDistance;
      leftup[1] = position[1] - leftupDistance;

      int rightdown[2];
      int rightdownDistance = min(4, MapSize[0] - 1 - position[0], MapSize[1] - 1 - position[1]);
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


    }


}