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
using KalServer.AI;

namespace KalServer
{
    public class Monster : GameCharacter
    {
        private const int AUTOBEHEAD_TIME = 4000;
        private const int DESPAWN_TIME = 1000;

        private List<Player> knownObjects = new List<Player>();

        private MapNode myNode;
        private Spawn mySpawn;

        private Timer beheadTimer;
        private Timer despawnTimer;

        private bool isKilled;

        #region Properties
        public Spawn Spawn { get { return this.mySpawn; } }
        public bool IsKilled { get { return this.isKilled; } set { this.isKilled = value; } }
        #endregion

        public Monster(MapNode start, Spawn pSpawn)
        {
            start.Used = true;
            this.mySpawn = pSpawn;
            this.myNode = start;
            this.Position = start.Position;

            this.HPAktuell = 100;
            this.hpMaximal = 100;
        }

        public bool IsPlayerInRange(Player pPlayer)
        {
            if (!knownObjects.Contains(pPlayer))
            {
                return false;
            }
            else return true;
        }

        public void AddPlayerInRange(Player pPlayer)
        {
            if (!knownObjects.Contains(pPlayer))
            {
                knownObjects.Add(pPlayer);
                Console.WriteLine("[MOB: {0}] Player {1} added to KnownList!", 
                    this.UniqueID, pPlayer.CharacterName);
            }
        }

        public void RemovePlayerInRange(Player pPlayer)
        {
            if (knownObjects.Contains(pPlayer))
            {
                knownObjects.Remove(pPlayer);
                Console.WriteLine("[MOB: {0}] Player {1} removed from KnownList!", 
                    this.UniqueID, pPlayer.CharacterName);
            }
        }

        public void setNode(MapNode node)
        {
            this.myNode.Used = false;
            this.myNode = node;
            node.Used = true;
            this.charPosition = this.myNode.Position;
            return;
        }

        public void AttackedByPlayer(Player pAttacker)
        {
            /* Monster gets attacked by a player with normal 
             * attack (without skill). This will also be handled by SkillHandler after
             * the next update
            */
            byte ebDamage = 0;
            byte normalDamage = World.GetRandomNumber((byte)pAttacker.MinPhysicalDMG, 
                                                      (byte)pAttacker.MaxPhysicalDMG);


            if ((ebDamage % 3) == 0) ebDamage = World.GetRandomNumber(1, 25);

            hpAktuell = hpAktuell - normalDamage - ebDamage;
            
            /* Debug message */
            Console.WriteLine("[MOB: {0}] HP atm: {1}, ConnID: {2}", uniqueID, hpAktuell, pAttacker.UniqueID);
            
            if (hpAktuell > 0)
            {
                /* The MOB isn't dead */
                broadcastPacket(new StandardAttack(pAttacker.UniqueID, uniqueID, normalDamage, ebDamage, 1));
            }
            else
            {
                /* The MOB is dead now. */
                this.OnDie(pAttacker);
            }
        }

        private void OnDie(Player pAttacker)
        {
            isKilled = true;

            /* Debug message */
            Console.WriteLine("[MOB: {0}] Got killed!", uniqueID);
            
            broadcastPacket(new PlayAnimation(uniqueID, 8));
            pAttacker.sendPacket(new PlayAnimation(uniqueID, 8));

            myNode.Used = false;
            
            beheadTimer = new Timer(new TimerCallback(OnBehead), pAttacker, AUTOBEHEAD_TIME, Timeout.Infinite);

            mySpawn.RespawnMob(uniqueID);
        }

        public void OnBehead(Object pAttacker)
        {
            if (beheadTimer != null) beheadTimer.Dispose();
            despawnTimer = new Timer(new TimerCallback(Despawn), pAttacker, DESPAWN_TIME, Timeout.Infinite);
            return;
        }

        /* Despawns the mob. I think this calls the destructor of the mob inside the client */
        public void Despawn(Object pAttacker)
        {
            despawnTimer.Dispose();
            broadcastPacket(new Despawn(uniqueID));
            knownObjects.Clear();
            return;
        }

        /* The monster gets damage */
        public void getDamage(ushort damageTaken, Player pAttacker)
        {
            hpAktuell = hpAktuell - damageTaken;
            if (hpAktuell <= 0)
            {
                broadcastPacket(new MonsterDie(uniqueID));
                OnDie(pAttacker);
            }
        }

        public void broadcastPacket(Packet p)
        {
            foreach (Player otherPlayer in knownObjects)
            {
                otherPlayer.sendPacket(p);
            }
        }
            

        
    }
}
