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
using System.Data;
using System.Collections.Generic;

using Mono.Data.SqliteClient;

//using KalServer.ServerPackets;
using KalServer.Packets;
using KalServer.Commands;

namespace KalServer
{
    public class Player : GameCharacter
    {
        private int dbID;
        private string charName;
        private byte hairType;
        private byte faceType;

        /******* Race *******
         * 0    = Knight    *
         * 1    = Mage      *
         * 2    = Archer    *
         ********************/
        private byte pRace;

        /*************** Job ****************
         * 1    = Scholar                   *
         * 2    = Literary Man              *
         * 4    = Hermit                    *
         * 8    = Chairperson Of Jong-Bang  *
         * 16   = Ascetic                   *
         * 32   = Military Adviser          *
         ************************************/
        private byte pJob;

        private int pExperience = 0;

        private Connection pConnection;
        private Inventory pInventory;
        private List<Player> knownPlayers;

        public string CharacterName { get { return this.charName; } set { this.charName = value; } }
        public byte Hair { get { return this.hairType; } set { this.hairType = value; } }
        public byte Face { get { return this.faceType; } set { this.faceType = value; } }
        public byte Class { get { return this.pRace; } set { this.pRace = value; } }
        public byte Speciality { get { return this.pJob; } set { this.pJob = value; } }
        public int Exp { get { return this.pExperience; } set { this.pExperience = value; } }

        public Inventory Inventory { get { return this.pInventory; } }
        public Connection Connection { get { return this.pConnection; } set { this.pConnection = value; } }

        public Player(int PID)
        {
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT * FROM Player WHERE PID = " + PID;
            IDataReader dbReader = dbCommand.ExecuteReader();

            if (dbReader.Read())
            {
                this.dbID = dbReader.GetInt32(1);
                this.charName = dbReader.GetString(2);
                this.SetStrength(dbReader.GetByte(3));
                this.SetHealth(dbReader.GetByte(4));
                this.SetIntelligence(dbReader.GetByte(5));
                this.SetWisdom(dbReader.GetByte(6));
                this.SetAgility(dbReader.GetByte(7));
                this.charPosition.X = dbReader.GetInt32(8);
                this.charPosition.Y = dbReader.GetInt32(9);
                this.charPosition.Z = dbReader.GetInt32(10);
                this.pRace = dbReader.GetByte(11);
                this.pJob = dbReader.GetByte(12);
                this.charLevel = dbReader.GetByte(13);
                this.faceType = dbReader.GetByte(14);
                this.hairType = dbReader.GetByte(15);
                this.pExperience = dbReader.GetInt32(16);
                this.hpAktuell = dbReader.GetInt16(17);
                this.manaAktuell = dbReader.GetInt16(18);

                this.pInventory = new Inventory(this.dbID);
            }
            else
            {
                throw new Exception("Someone tried to create an object of Player without a valid player-ID");
            }

            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;
            
            /* Always keep a list of other players in sight range */
            knownPlayers = new List<Player>();

            /* Get a unique ID to identify the player inside the client */
            uniqueID = World.GetID();
        }

        public void addKnownPlayer(Player pPlayer)
        {
            if (!knownPlayers.Contains(pPlayer))
            {
                knownPlayers.Add(pPlayer);
            }
        }

        public void removeKnownPlayer(Player pPlayer)
        {
            if (knownPlayers.Contains(pPlayer))
            {
                knownPlayers.Remove(pPlayer);
            }
        }

        public bool isPlayerInRange(Player pPlayer)
        {
            if (!knownPlayers.Contains(pPlayer))
            {
                return false;
            }
            else return true;
        }

        public void Move(sbyte dX, sbyte dY, sbyte dZ)
        {
            // update the own position
            Position.X += dX;
            Position.Y += dY;
            Position.Z += dZ;

            // Check if a mob comes in sight-range
            foreach (KeyValuePair<int, Monster> MOBEntry in World.Monsters)
            {
                // Mobs dürfen nur gespawnt werden, wenn sie nicht tot sind!
                if (MOBEntry.Value.IsKilled != true)
                {
                    if (World.GetDistance(MOBEntry.Value.Position, pConnection.Player.Position) < World.PLAYER_SIGHTRANGE)
                    {
                        if (!MOBEntry.Value.IsPlayerInRange(this))
                        {
                            Console.WriteLine("MOB {0} got spawned", MOBEntry.Value.UniqueID);
                            pConnection.Send(new MonsterSpawn(MOBEntry.Value));
                        }
                        MOBEntry.Value.AddPlayerInRange(this);     // When in range register the player with the mob
                    }
                    else if ((World.GetDistance(MOBEntry.Value.Position, pConnection.Player.Position) > World.PLAYER_SIGHTRANGE)
                        && (MOBEntry.Value.IsPlayerInRange(this) == true))
                    {
                        // Distance to the mob became larger but the player is still 
                        // registered. Remove the player from the monsters list.
                        MOBEntry.Value.RemovePlayerInRange(this);

                        // Remove the monster from the players client
                        pConnection.Send(new Despawn(MOBEntry.Value.UniqueID));
                    }
                }
            }

            // Now check if another player is in sight
            foreach (Player otherPlayer in World.Players)
            {
                if ((World.GetDistance(otherPlayer.Position, this.Position) < World.PLAYER_SIGHTRANGE)
                    && (otherPlayer != this))
                {
                    if (!otherPlayer.isPlayerInRange(this)) // already registered?
                    {
                        // spawn
                        otherPlayer.sendPacket(new PlayerSpawn(this, false));
                        sendPacket(new PlayerSpawn(otherPlayer, false));

                        // register
                        otherPlayer.addKnownPlayer(this);
                        this.addKnownPlayer(otherPlayer);
                    }
                    else
                    {
                        // if "conn" is already registered with "other" then it is okay
                        // to simply move the already spawned char
                        otherPlayer.sendPacket(new PlayerMove((uint)uniqueID, dX, dY, dZ));
                    }
                }
                else if ((World.GetDistance(otherPlayer.Position, this.Position) > World.PLAYER_SIGHTRANGE) &&
                    (otherPlayer.isPlayerInRange(this) == true) && (otherPlayer != this))
                {
                    // the client "conn" walked out of the sight range of "other"
                    otherPlayer.removeKnownPlayer(this);
                    removeKnownPlayer(otherPlayer);
                    otherPlayer.sendPacket(new Despawn(uniqueID));
                    sendPacket(new Despawn(otherPlayer.UniqueID));
                }
            }
        }

        public void ChatMessage(string Message)
        {
            if (Message[0] == '/')
            {
                Command cmd = Command.GetCommand(pConnection, Message);
                if (cmd != null) cmd.Execute();
            }
            else
            {
                broadcastPacket(new Chat(charName, Message));
                sendPacket(new Chat(charName, Message));
            }
        }

        public void Dress(int dbID)
        {
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT Item FROM Inventory WHERE ItemID=" + dbID;
            IDataReader dbReader = dbCommand.ExecuteReader();
            dbReader.Read();
            ushort item = (ushort)dbReader.GetInt16(0);

            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;
            
            // Stats updaten
            /*pack = new ServerNewValue(0x0A, 33);
            this.pConnection.Send(pack);
            pack = new ServerNewValue(0x0F, 128);
            this.pConnection.Send(pack);

            // Spielermodell updaten
            pack = new ServerDress(this.UniqueID, dbID, item);
            this.pConnection.Send(pack);
            */
        }

        public void Undress(int dbID)
        {
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT Item FROM Inventory WHERE ItemID=" + dbID;
            IDataReader dbReader = dbCommand.ExecuteReader();
            dbReader.Read();
            ushort item = (ushort)dbReader.GetInt16(0);

            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;
            /*
            pack = new ServerNewValue(0x0A, 31);
            pConnection.ClientSocket.Send(pack.getArray());
            pack = new ServerNewValue(0x0F, 125);
            pConnection.ClientSocket.Send(pack.getArray());

            pack = new ServerUndress(this.UniqueID, this.dbID, item);
            pConnection.ClientSocket.Send(pack.getArray());
            */
        }

        public void Spawn(bool ownChar)
        {
            // Register this connection with the world
            World.Players.Add(this);

            // Send skills
            sendPacket(new SendSkills());

            // Set inventory
            sendPacket(new SendInventory(this));

            // Spawn the own character
            sendPacket(new PlayerSpawn(this, true));

            // Spawn all MOBs inside the players sight range
            foreach (KeyValuePair<int, Monster> MOBEntry in World.Monsters)
            {
                if (World.GetDistance(pConnection.Player.Position, MOBEntry.Value.Position) < World.PLAYER_SIGHTRANGE)
                {
                    MOBEntry.Value.AddPlayerInRange(this);
                    sendPacket(new MonsterSpawn(MOBEntry.Value));
                }
            }

            /*
             * Spawn yourself near other players and the other players near
             * yourself when logging in */
            foreach (Player otherPlayer in World.Players)
            {
                if ((otherPlayer != this)
                    && (World.GetDistance(otherPlayer.Position, this.Position) < World.PLAYER_SIGHTRANGE))
                {
                    otherPlayer.addKnownPlayer(this);
                    addKnownPlayer(otherPlayer);
                    otherPlayer.sendPacket(new PlayerSpawn(this, false));
                    sendPacket(new PlayerSpawn(otherPlayer, false));
                }
            }

            sendPacket(new Unknown1());
        }

        public void AttackWithoutSkill(int mobID)
        {
            Console.WriteLine("Attack without skill. TargetID: {0}", mobID);
            World.Monsters[mobID].AttackedByPlayer(this);
        }

        public byte getRace()
        {
            return this.pRace;
        }

        public void sendPacket(Packet p)
        {
            pConnection.Send(p);
        }

        public void broadcastPacket(Packet p)
        {
            foreach (Player pPlayer in knownPlayers)
            {
                pPlayer.sendPacket(p);
            }
        }
    }
}
