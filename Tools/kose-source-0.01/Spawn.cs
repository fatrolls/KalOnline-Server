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
using System.Threading;
using KalServer.Packets;

namespace KalServer
{
    delegate void Callback(Object parameter);

    public struct SPAWNCOORDS
    {
        public MapNode k1;
        public MapNode k2;
    }

    public class Spawn
    {
        private const long RESPAWN_DELAY = 7500;    // If a MOB dies it is respawned after 7.5 sec

        private Dictionary<int, Monster> _mobs = new Dictionary<int, Monster>();
        private SPAWNCOORDS _coords;
        private byte _monstercount;
        private ushort _mobindex;

        public ushort MonsterIndex { get { return this._mobindex; } }
        
        public Spawn(SPAWNCOORDS coords, byte count, ushort index)
        {
            this._coords = coords;
            this._monstercount = count;
            this._mobindex = index;

            this.InitSpawn();
        }
        
        /* Fill the spawn with MOBs                        */
        private void InitSpawn()
        {
            MapNode start;
            Monster temp;

            for (int i = 0; i < _monstercount; i++)
            {
                start = SearchFreeNode();
                temp = new Monster(start, this);
                World.Monsters.Add(temp.UniqueID, temp);
                this._mobs.Add(temp.UniqueID, temp);
            }
        }

        /* Look randomly for a free node in the map         *
         * until one is found where the MOB can spawn       */
        private MapNode SearchFreeNode()
        {
            Random x = new Random();
            MapNode start;
            ObjectPosition pos = new ObjectPosition();
            if (_coords.k1.Position.X > _coords.k2.Position.X)
                pos.X = Server.rand.Next(_coords.k2.Position.X, _coords.k1.Position.X);
            else
                pos.X = Server.rand.Next(_coords.k1.Position.X, _coords.k2.Position.X);

            if (_coords.k1.Position.Y > _coords.k2.Position.Y)
                pos.Y = Server.rand.Next(_coords.k2.Position.Y, _coords.k1.Position.Y);
            else
                pos.Y = Server.rand.Next(_coords.k1.Position.Y, _coords.k2.Position.Y);

            start = World.Map.GetNearestNode(pos);
            if (start.Used) return SearchFreeNode();
            return start;
        }

        /* When a MOB dies it must be respawned after a certain     *
         * amount of time                                           */
        public void RespawnMob(int MOBUniqueID)
        {
            Timer timer = new Timer(new TimerCallback(OnRespawnMOB), 
                MOBUniqueID, RESPAWN_DELAY, Timeout.Infinite);
        }

        /* If a MOB from this spawn dies this method gets
         * called when the timer says its time for a respawn        */
        public void OnRespawnMOB(Object cbParam)
        {
            Monster temp = this._mobs[(int)cbParam];
            temp.setNode(SearchFreeNode());
            temp.HPAktuell = 100;
            temp.IsKilled = false;

            // Spawn the MOB for all players in SIGHTRANGE
            foreach (Player pPlayer in World.Players)
            {
                if (World.GetDistance(temp.Position, pPlayer.Position) < World.PLAYER_SIGHTRANGE)
                {
                    temp.AddPlayerInRange(pPlayer);
                    //@oldpackets
                    //pPlayer.sendPacket(new ServerMonsterSpawn(temp));
                    pPlayer.sendPacket(new MonsterSpawn(temp));
                }
            }
        }
    }
}
