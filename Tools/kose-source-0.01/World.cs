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
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using System.Data;

namespace KalServer
{
    class World
    {
        public const int PLAYER_SIGHTRANGE = 500;
        public const int MOB_AGGRORANGE = 200;

        private static Dictionary<int, Monster> _monsters = new Dictionary<int, Monster>();
        /*private static List<Connection> _players = new List<Connection>(); */
        private static TemplateManager templateManager = new TemplateManager();
        private static List<Player> connectedPlayers = new List<Player>();

        public static Dictionary<int, Monster> Monsters { get { return World._monsters; } }
        /*public static List<Connection> Players { get { return World._players; } }*/
        public static List<Player> Players { get { return World.connectedPlayers; } }

        public static Map Map = new Map();

        public static SkillHandler SkillHandler = new SkillHandler();

        public static void LoadMOBs()
        {
            Console.WriteLine("Initializing spawns");

            // Desire-Spawn D1R1
            SPAWNCOORDS c = new SPAWNCOORDS();
            c.k2 = World.Map.Knoten[88, 52];
            c.k1 = World.Map.Knoten[83, 64];
            Spawn sp = new Spawn(c, 5, 205);

            // Jealousy-Spawn D1R2
            SPAWNCOORDS d = new SPAWNCOORDS();
            d.k2 = World.Map.Knoten[59, 71];
            d.k1 = World.Map.Knoten[50, 81];
            Spawn sp1 = new Spawn(d, 5, 208);

            // Hatred-Spawn D1R4
            SPAWNCOORDS e = new SPAWNCOORDS();
            e.k2 = World.Map.Knoten[88, 95];
            e.k1 = World.Map.Knoten[82, 88];
            Spawn sp3 = new Spawn(e, 5, 209);

            Console.WriteLine("Spawns initialized");
            return;
        }

        /* Calculates the distance between two objects */
        public static int GetDistance(ObjectPosition p1, ObjectPosition p2)
        {
            int dX = 0;
            int dY = 0;
            int Distance = 0;

            dX = p1.X - p2.X;
            if (dX < 0) dX = dX * -1;
            dY = p1.Y - p2.Y;
            if (dY < 0) dY = dY * -1;

            dX = dX * dX;
            dY = dY * dY;
            int sumXY = dY + dX;

            Distance = (int)Math.Sqrt(sumXY);
            return Distance;
        }

        public static bool IsInRadius(ObjectPosition p1, ObjectPosition p2, int Radius)
        {
            if (GetDistance(p1, p2) <= Radius) return true;
            else return false;
        }

        private static int lastUsedID = 2824;

        public static int GetID()
        {
            lastUsedID++;
            return lastUsedID;
        }

        public static byte GetRandomNumber(byte min, byte max)
        {
            RNGCryptoServiceProvider csp = new RNGCryptoServiceProvider();
            byte[] numbers = new Byte[2];
            csp.GetBytes(numbers);

            double divisor = 256F / (max - min + 1);
            if (min > 0 || max < 255)
            {
                return (byte)((numbers[0] / divisor) + min);
            }
            return 0;                
        }
    }
}
