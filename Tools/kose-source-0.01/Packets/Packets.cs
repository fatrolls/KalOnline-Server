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
 * release site: http://kose.kalunderground.com . Don't bother to visit
 * them.
*/

using System;
using System.IO;
using System.Collections.Generic;

namespace KalServer.Packets
{
    public abstract class Packet
    {
        protected MemoryStream memStream;
        protected BinaryWriter streamWriter;
        private ushort packetLength;
        private byte packetType;
        private byte packetKey;
        private bool isCompiled;

        public Packet(byte pType, byte pKey, ushort pLength)
        {
            packetType = pType;
            packetLength = (ushort)(pLength + 3);
            packetKey = pKey;

            memStream = new MemoryStream((int)packetLength);
            streamWriter = new BinaryWriter(memStream);

            streamWriter.Write(packetLength);
            streamWriter.Write(packetType);
        }

        public Packet(byte pType, byte pKey)
        {
            packetType = pType;
            packetKey = pKey;
        }

        public void SetCapacity(ushort newCapacity)
        {
            packetLength = (ushort)(newCapacity + 3);
            memStream = new MemoryStream(packetLength);
            streamWriter = new BinaryWriter(memStream);
            streamWriter.Write(packetLength);
            streamWriter.Write(packetType);
        }

        public byte[] Compile(out int outLength)
        {
            if (!isCompiled)
            {
                memStream.Position = 0;
                streamWriter.Write(Coder.EncodeString(memStream.ToArray(), (uint)packetKey));
                isCompiled = true;
            }
            outLength = (int)memStream.Length;
            return memStream.ToArray();
        }
    }

    public sealed class Chat : Packet
    {
        public Chat(string chatName, string chatMessage)
            : base(0x3C, Server.FIRST_KEY)
        {
            SetCapacity((ushort)(chatMessage.Length + chatName.Length + 2));
            streamWriter.Write(chatName.ToCharArray());
            streamWriter.Write((byte)0x00);
            streamWriter.Write(chatMessage.ToCharArray());
            streamWriter.Write((byte)0x00);
        }
    }

    public sealed class PlayerMove : Packet
    {
        public PlayerMove(uint playerID, sbyte dX, sbyte dY, sbyte dZ)
            : base(0x23, Server.FIRST_KEY, 0x07)
        {
            streamWriter.Write(playerID);
            streamWriter.Write(dX);
            streamWriter.Write(dY);
            streamWriter.Write(dZ);
        }
    }

    public sealed class PlayerInfo : Packet
    {
        public PlayerInfo(Player pPlayer)
            : base(0x42, Server.FIRST_KEY, 54)
        {
            streamWriter.Write(pPlayer.Speciality);
            streamWriter.Write((short)0x00);
            streamWriter.Write((short)25); // Contribution
            streamWriter.Write(pPlayer.Stats.Strength);
            streamWriter.Write(pPlayer.Stats.Health);
            streamWriter.Write(pPlayer.Stats.Intelligence);
            streamWriter.Write(pPlayer.Stats.Wisdom);
            streamWriter.Write(pPlayer.Stats.Agility);
            streamWriter.Write((short)pPlayer.HPAktuell);
            streamWriter.Write((short)pPlayer.HPMaximal);
            streamWriter.Write(pPlayer.ManaAktuell);
            streamWriter.Write(pPlayer.ManaMaximal);
            streamWriter.Write(pPlayer.OnTarget);
            streamWriter.Write(pPlayer.Evasion);
            streamWriter.Write(pPlayer.Defense);
            streamWriter.Write(pPlayer.Absorption);
            streamWriter.Write(pPlayer.Exp);
            streamWriter.Write((int)0x00);                  // ?? 
            streamWriter.Write(pPlayer.MinPhysicalDMG);
            streamWriter.Write(pPlayer.MaxPhysicalDMG);
            streamWriter.Write(pPlayer.MinMagicalDMG);
            streamWriter.Write(pPlayer.MaxMagicalDMG);
            streamWriter.Write((short)10); // Free SP
            streamWriter.Write((short)10); // Max SP
            streamWriter.Write((byte)10); // Fire Resi
            streamWriter.Write((byte)10); // Ice Resi
            streamWriter.Write((byte)10); // Lightning Resi
            streamWriter.Write((byte)10); // Curse Resi
            streamWriter.Write((byte)10); // Non elemental resi
            streamWriter.Write((int)9999); // Rage
        }
    }

    public sealed class PlayerSpawn : Packet
    {
        public PlayerSpawn(Player pPlayer, bool ownChar)
            : base(0x32, Server.FIRST_KEY)
        {
            SetCapacity((ushort)(59 + pPlayer.CharacterName.Length));

            streamWriter.Write(pPlayer.UniqueID);
            streamWriter.Write(pPlayer.CharacterName.ToCharArray());
            streamWriter.Write((byte)0x00);

            if (ownChar) streamWriter.Write((byte)((byte)0x80 | pPlayer.Class));
            else streamWriter.Write(pPlayer.Class);

            streamWriter.Write(pPlayer.Position.X);
            streamWriter.Write(pPlayer.Position.Y);
            streamWriter.Write(pPlayer.Position.Z);
            streamWriter.Write((short)0x02);
            streamWriter.Write((byte)0x00);     // 0x02 = dead
            streamWriter.Write((byte)0x00);
            streamWriter.Write((short)0x00);

            if (pPlayer.Inventory.Weapon != null)
                streamWriter.Write(pPlayer.Inventory.Weapon.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Shield != null)
                streamWriter.Write(pPlayer.Inventory.Shield.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Helmet != null)
                streamWriter.Write(pPlayer.Inventory.Helmet.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Chest != null)
                streamWriter.Write(pPlayer.Inventory.Chest.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Shorts != null)
                streamWriter.Write(pPlayer.Inventory.Shorts.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Gloves != null)
                streamWriter.Write(pPlayer.Inventory.Gloves.Index);
            else
                streamWriter.Write((short)0);

            if (pPlayer.Inventory.Boots != null)
                streamWriter.Write(pPlayer.Inventory.Boots.Index);
            else
                streamWriter.Write((short)0);

            streamWriter.Write(pPlayer.Face);
            streamWriter.Write(pPlayer.Hair);
            for (int i = 0; i < 19; i++) streamWriter.Write((byte)0x00);
        }
    }

    public sealed class Despawn : Packet
    {
        public Despawn(int despawnID)
            : base(0x38, Server.FIRST_KEY, 4)
        {
            streamWriter.Write(despawnID);
        }
    }

    public sealed class Dress : Packet
    {
        public Dress(int playerID, int playerDBID, ushort itemID)
            : base(0x05, Server.FIRST_KEY, 10)
        {
            streamWriter.Write(playerID);
            streamWriter.Write(playerDBID);
            streamWriter.Write(itemID);
        }
    }

    public sealed class Undress : Packet
    {
        public Undress(int playerID, int playerDBID, ushort itemID)
            : base(0x06, Server.FIRST_KEY, 10)
        {
            streamWriter.Write(playerID);
            streamWriter.Write(playerDBID);
            streamWriter.Write(itemID);
        }
    }

    public sealed class ExecuteSkill : Packet
    {
        public ExecuteSkill(int playerID, int mobID, byte skillNr, byte skillLvl, byte bHit, ushort baseDMG, ushort ebDMG)
            : base(0x3f, Server.FIRST_KEY, 16)
        {
            streamWriter.Write(skillNr);
            streamWriter.Write(playerID);
            streamWriter.Write(mobID);
            streamWriter.Write((byte)0x01);
            streamWriter.Write(skillLvl);
            streamWriter.Write(baseDMG);
            streamWriter.Write(ebDMG);
            streamWriter.Write(bHit);
        }
    }

    public sealed class Init : Packet
    {
        public Init(byte firstKey, byte bitEvent)
            : base(0x2a, 0x00, 24)
        {
            streamWriter.Write((byte)0x47);
            streamWriter.Write((byte)0xa7);
            streamWriter.Write((byte)0xf6);
            streamWriter.Write((byte)0x16);
            streamWriter.Write(firstKey);
            streamWriter.Write((byte)0xd4);
            streamWriter.Write((byte)0x4c);
            streamWriter.Write((byte)0x7e);
            streamWriter.Write((byte)0x44);
            streamWriter.Write((byte)0x4c);
            streamWriter.Write((byte)0x0d);
            streamWriter.Write((byte)0x2d);
            streamWriter.Write((byte)0x45);
            streamWriter.Write((byte)0x61);
            streamWriter.Write((byte)0x1e);
            streamWriter.Write((byte)0x00);
            streamWriter.Write((byte)0x00);
            streamWriter.Write(bitEvent);
            streamWriter.Write((byte)0x00);
            streamWriter.Write((byte)0x00);
            streamWriter.Write((byte)0x00);
            streamWriter.Write((byte)0x01);
            streamWriter.Write((byte)0x12);
            streamWriter.Write((byte)0xfc);

        }
    }

    public sealed class LoginOK : Packet
    {
        public LoginOK()
            : base(0x04, Server.FIRST_KEY, 1)
        {
            streamWriter.Write((byte)0x00);
        }
    }

    public enum LOGIN_ERROR
    {
        UNDEFINED = 0x01,
        WRONGID = 0x02,
        WRONG_PASS = 0x03,
        CONNECT_LATER = 0x04,
        BLOCKED = 0x05,
        ID_EXPIRED = 0x06,
        TOO_YOUNG = 0x07,
        NOT_ALLOWED = 0x08,
    }

    public sealed class LoginError : Packet
    {
        public LoginError(LOGIN_ERROR errorNumber)
            : base(0x2b, Server.FIRST_KEY, 1)
        {
            streamWriter.Write((byte)errorNumber);
        }
    }

    public sealed class MonsterMove : Packet
    {
        public MonsterMove(int mobID, sbyte dX, sbyte dY, bool isRunning)
            : base(0x24, Server.FIRST_KEY, 7)
        {
            streamWriter.Write(mobID);
            streamWriter.Write(dX);
            streamWriter.Write(dY);
            streamWriter.Write(isRunning);
        }
    }

    public sealed class MonsterMoveEnd : Packet
    {
        public MonsterMoveEnd(int mobID, sbyte dX, sbyte dY, bool isRunning)
            : base(0x25, Server.FIRST_KEY, 7)
        {
            streamWriter.Write(mobID);
            streamWriter.Write(dX);
            streamWriter.Write(dY);
            streamWriter.Write(isRunning);
        }
    }

    public sealed class MonsterDie : Packet
    {
        public MonsterDie(int mobID)
            : base(0x40, Server.FIRST_KEY, 5)
        {
            streamWriter.Write(mobID);
            streamWriter.Write((byte)0x00);
        }
    }

    public sealed class MonsterSpawn : Packet
    {
        public MonsterSpawn(Monster spawnMob)
            : base(0x33, Server.FIRST_KEY, 41)
        {
            streamWriter.Write(spawnMob.Spawn.MonsterIndex);

            streamWriter.Write(spawnMob.UniqueID);
            streamWriter.Write(spawnMob.Position.X);
            streamWriter.Write(spawnMob.Position.Y);

            streamWriter.Write((short)2);
            streamWriter.Write(spawnMob.HPAktuell);
            streamWriter.Write(spawnMob.HPMaximal);
            for (int i = 0; i < 17; i++) streamWriter.Write((byte)0x00);
        }
    }

    public sealed class ChangeValue : Packet
    {
        public ChangeValue(byte whichValue, ushort newValue)
            : base(0x45, Server.FIRST_KEY, 3)
        {
            streamWriter.Write(whichValue);
            streamWriter.Write(newValue);
        }

        public ChangeValue(int newExp, int newRage)
            : base(0x45, Server.FIRST_KEY, 17)
        {
            streamWriter.Write((byte)0x19);
            streamWriter.Write(newRage);
            streamWriter.Write((int)0);
            streamWriter.Write(newExp);
            streamWriter.Write((int)0);
        }
    }

    public sealed class PostNotice : Packet
    {
        public PostNotice(string messageText)
            : base(0x0f, Server.FIRST_KEY)
        {
            SetCapacity((ushort)(messageText.Length + 1));
            streamWriter.Write(messageText.ToCharArray());
            streamWriter.Write((byte)0x00);
        }
    }

    public sealed class NPCSpawn : Packet
    {
        public NPCSpawn(int internalID, ushort npcIndex, byte npcShape, int pX, int pY, int pZ)
            : base(0x34, Server.FIRST_KEY, 29)
        {
            streamWriter.Write(internalID);         // Internal ID of the NPC
            streamWriter.Write(npcIndex);           // ID of the NPC
            streamWriter.Write(npcShape);           // Shape of the NPC
            streamWriter.Write(pX);                 // Position X
            streamWriter.Write(pY);                 // Position Y
            streamWriter.Write(pZ);                 // Position Z
            streamWriter.Write((int)0x00);          // Heading

            for (int i = 0; i < 6; i++) streamWriter.Write((byte)0x00);
        }
    }

    public sealed class PlayAnimation : Packet
    {
        public PlayAnimation(int mobID, byte animID)
            : base(0x3d, Server.FIRST_KEY, 5)
        {
            streamWriter.Write(mobID);
            streamWriter.Write(animID);
        }

        public PlayAnimation(int mobID, int playerID, byte skillID)
            : base(0x3d, Server.FIRST_KEY, 10)
        {
            streamWriter.Write(playerID);
            streamWriter.Write((byte)0x05);
            streamWriter.Write(skillID);
            streamWriter.Write(mobID);
        }
    }

    public sealed class SendInventory : Packet
    {
        public SendInventory(Player pPlayer)
            : base(0x04, Server.FIRST_KEY)
        {
            SetCapacity((ushort)((pPlayer.Inventory.ItemCount * 26) + 1));
            streamWriter.Write((byte)pPlayer.Inventory.ItemCount);
            foreach (Item item in pPlayer.Inventory)
            {
                streamWriter.Write(item.DBID);
                streamWriter.Write(item.Index);
                streamWriter.Write(item.Prefix);
                streamWriter.Write(item.Info);
                streamWriter.Write(item.Count);
                streamWriter.Write(item.MaxEndurance);
                streamWriter.Write(item.CurrentEndurance);
                streamWriter.Write(item.SetGem);
                streamWriter.Write(item.AttackTalis);
                streamWriter.Write(item.MagicTalis);
                streamWriter.Write(item.Defense);
                streamWriter.Write(item.OnTargetPoint);
                streamWriter.Write(item.Dodge);
                streamWriter.Write(item.Protect);
                streamWriter.Write(item.EBLevel);
                streamWriter.Write(item.EBRate);
            }
        }
    }

    public sealed class SendSkills : Packet
    {
        public SendSkills()
            : base(0x10, Server.FIRST_KEY, 10)
        {
            SetCapacity(7);
            streamWriter.Write((byte)3);    // Number of skills that are send
            streamWriter.Write((byte)0);    // SkillID:     0
            streamWriter.Write((byte)1);    // Skilllevel:  1
            streamWriter.Write((byte)1);    // SkillID:     1
            streamWriter.Write((byte)1);    // Skilllevel:  1
            streamWriter.Write((byte)4);    // SkillID:     4
            streamWriter.Write((byte)5);    // Skilllevel:  5
        }
    }

    public sealed class SetCamera : Packet
    {
        public SetCamera(Player pPlayer, ushort mapID)
            : base(0x1b, Server.FIRST_KEY, 10)
        {
            streamWriter.Write(mapID);
            streamWriter.Write(pPlayer.Position.X);
            streamWriter.Write(pPlayer.Position.Y);
        }
    }

    public sealed class ShowEffect : Packet
    {
        public enum Effect
        {
            TakeMedicine = 0x01,
            LevelUp = 0x03,
            Rebirth = 0x04,
            PowerImpr = 0x05,
            DamageRed = 0x06,
            EBImpr = 0x07,
            AccuImpr = 0x08,
            EvaImpr = 0x09,
            PerfectDefense = 0x0A,
            HPAbsorb = 0x0B,
            TigerClaws = 0x0C,
            BearSkin = 0x0D,
            Wisdom = 0x0E,
            Foresight = 0x0F,
            EagleWings = 0x10,
            FishingStone = 0x12,
            EXPStone = 0x13,
            WealthStone = 0x14,
            LuckyKey = 0x15,
            LuckyStone = 0x16,
            LightningBlow = 0x21
        }

        public ShowEffect(int playerID, byte effectID)
            : base(0x49, Server.FIRST_KEY, 5)
        {
            streamWriter.Write(playerID);
            streamWriter.Write(effectID);
        }
    }

    public enum HitIndicator
    {
        EvadedHit = 0x00,
        NormalHit = 0x01,
        CriticalHit = 0x02
    }

    public sealed class StandardAttack : Packet
    {
        public StandardAttack(int attackerID, int victimID, ushort baseDamage, ushort ebDamage, byte bHit)
            : base(0x3e, Server.FIRST_KEY, 13)
        {
            streamWriter.Write(attackerID);
            streamWriter.Write(victimID);
            streamWriter.Write(baseDamage);
            streamWriter.Write(ebDamage);
            streamWriter.Write(bHit);
        }
    }

    public sealed class Teleport : Packet
    {
        public Teleport(int pX, int pY, int pZ, byte bMap)
            : base(0x46, Server.FIRST_KEY, 14)
        {
            streamWriter.Write((byte)0x46);
            streamWriter.Write((byte)0x00);
            streamWriter.Write(pX);
            streamWriter.Write(pY);
            streamWriter.Write(pZ);
            streamWriter.Write(bMap);
        }
    }

    public sealed class Unknown : Packet
    {
        public Unknown()
            : base(0x16, Server.FIRST_KEY, 1)
        {
            streamWriter.Write((byte)0x00);
        }
    }

    public sealed class Unknown1 : Packet
    {
        public Unknown1()
            : base(0x1C, Server.FIRST_KEY, 1)
        {
            streamWriter.Write((byte)0x0B);
        }
    }

    public sealed class PlayerList : Packet
    {
        public PlayerList(List<PlayerListItem> listPlayers)
            : base(0x11, Server.FIRST_KEY)
        {
            int packetSize = 10;
            for (int i=0;i<listPlayers.Count;i++)
            {
                packetSize = packetSize + listPlayers[i].strName.Length;
                packetSize = packetSize + 19;
                packetSize = packetSize + listPlayers[i].lstItems.Count * 2;
            }
            SetCapacity((ushort)packetSize);

            streamWriter.Write((int)0x0);
            streamWriter.Write((byte)0x0);
            streamWriter.Write((byte)listPlayers.Count);

            // Submit data for every character
            for (int i = 0; i < listPlayers.Count; i++)
            {
                streamWriter.Write(listPlayers[i].dbID);
                streamWriter.Write(listPlayers[i].strName.ToCharArray());
                streamWriter.Write((byte)0x00);
                streamWriter.Write(listPlayers[i].bClass);
                streamWriter.Write(listPlayers[i].bLevel);
                streamWriter.Write((int)0x0);
                streamWriter.Write(listPlayers[i].bStrength);
                streamWriter.Write(listPlayers[i].bHealth);
                streamWriter.Write(listPlayers[i].bIntelli);
                streamWriter.Write(listPlayers[i].bWisdom);
                streamWriter.Write(listPlayers[i].bAgility);
                streamWriter.Write(listPlayers[i].bFace);
                streamWriter.Write(listPlayers[i].bHair);
                streamWriter.Write((byte)listPlayers[i].lstItems.Count);
                for (int j = 0; j < listPlayers[i].lstItems.Count; j++)
                {
                    streamWriter.Write(listPlayers[i].lstItems[j]);
                }
            }
            streamWriter.Write((int)0x03);
            listPlayers.Clear();
        }
    }
}
