
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

namespace KalServer.Packets
{
    public class PacketHandlers
    {
        private static Dictionary<byte, PacketHandler> packetHandlers;

        static PacketHandlers()
        {
            packetHandlers = new Dictionary<byte, PacketHandler>();
            Register(0x02, Login);
            Register(0x0A, CharacterSelect);
            Register(0x0B, SpawnPlayer);
            Register(0x0F, Attack);
            Register(0x10, SkillExecute);
            Register(0x11, Chat);
            Register(0x14, Move);
            Register(0x15, Move);
            Register(0x16, NPCTalk);
            Register(0x2B, SkillRequest);
            Register(0x41, Dress);
            Register(0x42, Undress);
            Register(0xA3, SendInit);
        }

        private static void Register(byte packetID, OnPacketReceive receiveMethod)
        {
            packetHandlers.Add(packetID, new PacketHandler(packetID, receiveMethod));
        }

        public static PacketHandler GetHandler(byte packetID)
        {
            PacketHandler pHandler = null;
            try
            {
                pHandler = packetHandlers[packetID];
            }
            catch (Exception)
            {
                Console.WriteLine("Couldn't find a packet handler for packet with ID: {0}", packetID);
            }
            return pHandler;
        }

        private static void Chat(Connection pConn, PacketReader pReader)
        {
            string chatMessage = pReader.ReadString();
            Console.WriteLine("Chatpacket| Message: {0}", chatMessage);
            pConn.Player.ChatMessage(chatMessage);
            return;
        }

        private static void CharacterSelect(Connection pConn, PacketReader pReader)
        {
            int characterID = (int)pReader.ReadUInt32();
            pConn.PlayerSelect(characterID);
            return;
        }

        public static void Login(Connection pConn, PacketReader pReader)
        {
            string strUser = pReader.ReadString();
            string strPass = pReader.ReadString();
            Console.WriteLine("Username: {0} | Password: {1} tried to log in", strUser, strPass);
            pConn.UserLogin(strUser, strPass);
            return;
        }

        public static void SendInit(Connection pConn, PacketReader pReader)
        {
            pConn.SendInit();
            return;
        }

        public static void SpawnPlayer(Connection pConn, PacketReader pReader)
        {
            pConn.Player.Spawn(true);
            return;
        }

        public static void Move(Connection pConn, PacketReader pReader)
        {
            sbyte dX = pReader.ReadSByte();
            sbyte dY = pReader.ReadSByte();
            sbyte dZ = pReader.ReadSByte();
            pConn.Player.Move(dX, dY, dZ);
            return;
        }

        public static void NPCTalk(Connection pConn, PacketReader pReader)
        {
            uint npcID = pReader.ReadUInt32();
            Console.WriteLine("Player {0} talked to NPC {1}", pConn.Player.CharacterName, npcID);
         
            return;
        }

        public static void Attack(Connection pConn, PacketReader pReader)
        {
            uint mobID;
            pReader.ReadByte();
            mobID = pReader.ReadUInt32();
            pConn.Player.AttackWithoutSkill((int)mobID);
            return;
        }

        public static void SkillRequest(Connection pConn, PacketReader pReader)
        {
            byte skillID = pReader.ReadByte();
            uint mobID = pReader.ReadUInt32();

            OnSkillRequest requestMethod =
                SkillHandler.GetSkillRequestHandler(skillID, (SkillHandler.Race)pConn.Player.Class);

            requestMethod(pConn.Player, (int)mobID);
            return;
        }

        public static void SkillExecute(Connection pConn, PacketReader pReader)
        {
            byte skillID = pReader.ReadByte();
            byte skillLevel = pReader.ReadByte();
            uint mobID = pReader.ReadUInt32();

            OnSkillExecute executeMethod =
                SkillHandler.GetSkillExecuteHandler(skillID, (SkillHandler.Race)pConn.Player.Class);

            executeMethod(pConn.Player, (int)mobID);
            return;
        }

        public static void Dress(Connection pConn, PacketReader pReader)
        {
            uint itemDbID = pReader.ReadUInt32();
            Console.WriteLine("Start wearing item {0}", itemDbID);
            return;
        }

        public static void Undress(Connection pConn, PacketReader pReader)
        {
            uint itemDbID = pReader.ReadUInt32();
            Console.WriteLine("Stop wearing item {0}", itemDbID);
            return;
        }
    }
}
