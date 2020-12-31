/* KalOnline Server Emulator                                 
 * Copyright (C) 2006 ingam0r <ingam0r@m2x.eu> 
 *                                                     
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 2 of the License, or (at 
 * your option) any later version.                                     
 *                                                   
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA                                                     *
 *                                                               
 * If you make useful changes to the code please contribute them to this
 * project. I would be happy to include your useful changes in one of the 
 * next releases. Thank you! 
 * You can find the latest release of this source code at our official
 * release site: http://www.kalunderground.com . Don't bother to visit
 * them.
*/
						
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace KalServer
{
    class Map
    {
        public const ushort GRIDSIZE = 32;
        public const ushort TILESIZE_X = 256;
        public const ushort TILESIZE_Y = 256;
        public const ushort X_MULTIPLIKATOR = 6;
        public const ushort Y_MULTIPLIKATOR = 4;

        private MapNode[,] knoten = new MapNode[TILESIZE_X, TILESIZE_Y];

        private MapNode startknoten;

        public MapNode Start { get { return this.startknoten; } }
        public MapNode[,] Knoten { get { return this.knoten; } }

        private bool[,] mapArray = new bool[TILESIZE_X, TILESIZE_Y];

        public Map()
        {
            int KnotenZahl = 0;
            try
            {
                FileStream fs = new FileStream("maps/d1.ksm", FileMode.Open);
                BinaryReader br = new BinaryReader(fs);
                fs.Position = 1;
                for (int i = 0; i < 256; i++)
                {
                    for (int j = 0; j < 256; j++)
                    {
                        if (br.ReadUInt16() > 0) mapArray[j, i] = false;
                        else mapArray[j, i] = true;
                        fs.Position += 2;
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0} Stacktrace: {1}", e.Message, e.StackTrace);
            }

            /* Create and connect the nodes
             * ----------------------------*/
            for (int y = 0; y < TILESIZE_Y; y++)
            {
                for (int x = 0; x < TILESIZE_X; x++)
                {
                    if (mapArray[x, y] == true)
                    {
                        knoten[x, y] = new MapNode(
                            X_MULTIPLIKATOR * 256 * GRIDSIZE + x * GRIDSIZE,
                            Y_MULTIPLIKATOR * 256 * GRIDSIZE + y * GRIDSIZE, 
                            19993);
                        KnotenZahl++;

                        if (x != 0)
                        {
                            if (mapArray[x - 1, y] == true)
                            {
                                knoten[x, y].LeftNeighbour = knoten[x - 1, y];
                                knoten[x - 1, y].RightNeighbour = knoten[x, y];
                            }
                        }
                        if (y != 0)
                        {
                            if (mapArray[x, y - 1] == true)
                            {
                                knoten[x, y].TopNeighbour = knoten[x, y - 1];
                                knoten[x, y - 1].BottomNeighbour = knoten[x, y];
                            }
                        }
                    }
                }
            }

            this.startknoten = knoten[47, 153];
        }

        public MapNode GetNearestNode(ObjectPosition Position)
        {
            int tile_x = Position.X / (TILESIZE_X * GRIDSIZE);
            int tile_y = Position.Y / (TILESIZE_Y * GRIDSIZE);

            int nodeX = (Position.X / GRIDSIZE) - (TILESIZE_X * X_MULTIPLIKATOR);
            int nodeY = (Position.Y / GRIDSIZE) - (TILESIZE_Y * Y_MULTIPLIKATOR);
            return this.knoten[nodeX, nodeY];
        }
    }
}
