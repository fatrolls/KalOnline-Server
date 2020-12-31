
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
using System.IO;
using System.Text;

namespace KalServer.Packets
{
    public class PacketReader
    {
        private MemoryStream memStream;
        private BinaryReader binReader;

        private ushort packetLength;
        private byte packetType;

        public byte PacketType { get { return packetType; } }
        public ushort PacketSize { get { return packetLength; } }

        public PacketReader(byte[] packetBuffer, uint packetKey)
        {
            if (packetBuffer[2] != 0xA3)
                packetBuffer = Coder.DecodeString(packetBuffer, packetKey);

            memStream = new MemoryStream(packetBuffer);
            binReader = new BinaryReader(memStream);

            packetLength = binReader.ReadUInt16();
            packetType = binReader.ReadByte();
        }

        public byte ReadByte()
        {
            byte readByte;

            readByte = binReader.ReadByte();
            return readByte;
        }

        public sbyte ReadSByte()
        {
            sbyte readSByte;

            readSByte = binReader.ReadSByte();
            return readSByte;
        }

        public ushort ReadUShort()
        {
            ushort readUShort;

            readUShort = binReader.ReadUInt16();
            return readUShort;
        }

        public uint ReadUInt32()
        {
            uint readInt;

            readInt = binReader.ReadUInt32();
            return readInt;
        }

        public string ReadString()
        {
            byte[] readString = new byte[1024];
            byte c;
            int charCount = 0;

            // Read from the stream until \0 is read
            while ((c = binReader.ReadByte()) != 0x00)
            {
                try
                {
                    readString[charCount] = c;
                    charCount++;
                }
                catch (ArgumentOutOfRangeException)
                {
                    Console.WriteLine("Received string was longer than 1024 byte!");
                    break;
                }
            }

            string returnString;
            try
            {
                returnString = Encoding.ASCII.GetString(readString, 0, charCount);
            }
            catch (Exception)
            {
                Console.WriteLine("There was an error while converting data to a string!");
                returnString = " ";
            }
            return returnString;
        }

    }
}
