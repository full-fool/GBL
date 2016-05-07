### gloabl variables including array, initialization



class Gobang extends Game
{
    bool isLegal(int position)
    {
      if(not (position[0]>=0 and position[0]<MapSize[0] and position[1]>=0 and position[1]<MapSize[1]))
        return false;
      if(SpriteOwnerId[position[0] * Mapsize[0] + position[1]]@mygame == -1)
        return true;
      else return false;
    }
    


}