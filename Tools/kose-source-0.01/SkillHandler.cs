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

using KalServer.Packets;

namespace KalServer
{
    public delegate void OnSkillRequest(Player pAttacker, int mobID);
    public delegate void OnSkillExecute(Player pAttacker, int mobID);
    
    /* This is the skill-handler. It keeps the IDs of all skills for all classes.
     * You can register two methods to be called for each skill. (see RegisterSkillRequest()
     * and RegisterSkillExecute() ) 
     * 
     * When a client wants to attack a monster it REQUESTS the skill. After the request is 
     * received by the server some preparations are made for the skill to be executed (eg. 
     * play an animation, spawn some wicked things, whatever you wanna do).
     * 
     * After the warm-up time of a skill the client sends an EXECUTE command. This would be 
     * where you calculate the damage, let the mob recalculate its range, or something like
     * that.
    */
    public class SkillHandler
    {
        public enum Race
        {
            Knight = 0x00,
            Mage = 0x01,
            Archer = 0x02
        }

        static Dictionary<int, OnSkillRequest> m_KnightRequests;
        static Dictionary<int, OnSkillExecute> m_KnightExecutes;
        static Dictionary<int, OnSkillRequest> m_MageRequests;
        static Dictionary<int, OnSkillExecute> m_MageExecutes;
        static Dictionary<int, OnSkillRequest> m_ArcherRequests;
        static Dictionary<int, OnSkillExecute> m_ArcherExecutes;

        static SkillHandler()
        {
            m_KnightRequests = new Dictionary<int, OnSkillRequest>();
            m_KnightExecutes = new Dictionary<int, OnSkillExecute>();
            m_MageRequests = new Dictionary<int, OnSkillRequest>();
            m_MageExecutes = new Dictionary<int, OnSkillExecute>();
            m_ArcherRequests = new Dictionary<int, OnSkillRequest>();
            m_ArcherExecutes = new Dictionary<int, OnSkillExecute>();

            RegisterSkillRequest(1, Race.Mage, new OnSkillRequest(BeheadSkillRequest));
            RegisterSkillExecute(1, Race.Mage, new OnSkillExecute(BeheadSkillExecute));
            RegisterSkillRequest(4, Race.Mage, new OnSkillRequest(LightningSkillRequest));
            RegisterSkillExecute(4, Race.Mage, new OnSkillExecute(LightningSkillExecute));            
        }

        public static void RegisterSkillRequest(int skillID, Race enRace, OnSkillRequest dRequest)
        {
            switch (enRace)
            {
                case Race.Knight:
                    m_KnightRequests.Add(skillID, dRequest);
                    break;

                case Race.Mage:
                    m_MageRequests.Add(skillID, dRequest);
                    break;

                case Race.Archer:
                    m_ArcherRequests.Add(skillID, dRequest);
                    break;
            }
            Console.WriteLine("RequestHandler added for skill {0} ({1})", skillID, enRace);
        }

        public static void RegisterSkillExecute(int skillID, Race enRace, OnSkillExecute dExecute)
        {
            switch (enRace)
            {
                case Race.Knight:
                    m_KnightExecutes.Add(skillID, dExecute);
                    break;

                case Race.Mage:
                    m_MageExecutes.Add(skillID, dExecute);
                    break;

                case Race.Archer:
                    m_ArcherExecutes.Add(skillID, dExecute);
                    break;
            }
            Console.WriteLine("ExecuteHandler added for skill {0} ({1})", skillID, enRace);
        }

        public static OnSkillRequest GetSkillRequestHandler(int skillID, Race enRace)
        {
            try
            {
                Dictionary<int, OnSkillRequest> dictMapping = null;

                switch (enRace)
                {
                    case Race.Knight:
                        dictMapping = m_KnightRequests;
                        break;

                    case Race.Mage:
                        dictMapping = m_MageRequests;
                        break;

                    case Race.Archer:
                        dictMapping = m_ArcherRequests;
                        break;
                }
                OnSkillRequest requestHandler = dictMapping[skillID];
                return requestHandler;
            }
            catch (KeyNotFoundException e)
            {
                Console.WriteLine("Someone tried to request a skill for that " + 
                                  "no handler exists. {0} {1}", e.Source, e.TargetSite);
            }
            catch (NullReferenceException)
            {
                // Should never ever happen -.-
                Console.WriteLine("Someone tried to request a skill for an unknown race!");
            }
            return null;
        }

        public static OnSkillExecute GetSkillExecuteHandler(int skillID, Race enRace)
        {
            try
            {
                Dictionary<int, OnSkillExecute> dictMapping = null;

                switch (enRace)
                {
                    case Race.Knight:
                        dictMapping = m_KnightExecutes;
                        break;

                    case Race.Mage:
                        dictMapping = m_MageExecutes;
                        break;

                    case Race.Archer:
                        dictMapping = m_ArcherExecutes;
                        break;
                }
                OnSkillExecute executeHandler = dictMapping[skillID];
                return executeHandler;
            }
            catch (KeyNotFoundException e)
            {
                Console.WriteLine("Someone tried to execute a skill for " +
                                  "that no handler exists. {0} {1}",
                                  e.Source, e.TargetSite);
            }
            catch (NullReferenceException)
            {
                // Should never ever happen -.-
                Console.WriteLine("Someone tried to request a skill for an unknown race!");
            }
            return null;
        }

        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
         * 
         * Here we go. Let's define the functions that get called whenever a skill is executed.     
         * This is the place where you wanna start to create your own custom skills. Perhaps some   
         * kind of scripting support will be added in the far future.   
         * 
        */
        public static void BeheadSkillRequest(Player pAttacker, int mobID)
        {
            // no implementation here :)
        }

        public static void BeheadSkillExecute(Player pAttacker, int mobID)
        {
            Monster attackedMob = World.Monsters[mobID];

            Packet attackPacket = new ExecuteSkill(pAttacker.UniqueID, attackedMob.UniqueID, 1, 1, 0, 0, 0);
            attackedMob.broadcastPacket(attackPacket);

            Packet aniPack = new PlayAnimation(mobID, 10);
            attackedMob.broadcastPacket(aniPack);

            attackedMob.OnBehead(pAttacker);
        }

        public static void LightningSkillRequest(Player pAttacker, int mobID)
        {
            Monster attackedMob = World.Monsters[mobID];
            attackedMob.broadcastPacket(new PlayAnimation(mobID, pAttacker.UniqueID, 4));
        }

        public static void LightningSkillExecute(Player pAttacker, int mobID)
        {
            Monster attackedMob = World.Monsters[mobID];
            Packet attackPacket = new ExecuteSkill(pAttacker.UniqueID, attackedMob.UniqueID, 4, 1, 1, 31, 0);
            attackedMob.broadcastPacket(attackPacket);
            attackedMob.getDamage((ushort)Server.rand.Next(100), pAttacker);
        }
    }
}
