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
using System.Net.Sockets;
using System.Threading;
using KalServer.Commands;
using KalServer.Packets;

namespace KalServer
{
    public class Connection
    {
        public const int BUFFERSIZE = 1024;

        private Socket connectedSocket;
        private Player connectedPlayer;
        private Account connectedAccount;
        private Object syncRoot = new Object();
        private uint _key;
        private byte[] receiveBuffer;

        public Account Account { get { return connectedAccount; } }
        public Player Player { get { return connectedPlayer; } }
        public Socket Socket { get { return connectedSocket; } }
        public byte[] Buffer { get { return receiveBuffer; } }

        public Connection(Socket pSocket)
        {
            connectedSocket = pSocket;
            receiveBuffer = new byte[BUFFERSIZE];
            _key = Server.FIRST_KEY;
        }

        public void Process(byte[] buffer)
        {
            lock (syncRoot)
            {
                PacketReader pReader = new PacketReader(buffer, _key);
                PacketHandler pHandler = PacketHandlers.GetHandler(pReader.PacketType);
                if (pHandler != null)
                {
                    OnPacketReceive pHandlerMethod = pHandler.OnReceive;
                    pHandlerMethod(this, pReader);
                }

                // Do not increment the counter if the packettype is 0xA3
                if (pReader.PacketType == 0xA3) return;

                if (this._key == 63)
                {
                    this._key = 0;
                }
                else
                {
                    this._key++;
                }
            }
        }

        public void Send(Packet p)
        {
            int packetLength = 0;
            byte[] sendBuffer = p.Compile(out packetLength);
            connectedSocket.BeginSend(sendBuffer, 0, packetLength, 0, 
                new AsyncCallback(SendCallback), connectedSocket);
        }

        private void SendCallback(IAsyncResult ar)
        {
            Socket handler = (Socket)ar.AsyncState;
            handler.EndSend(ar);
        }

        public void OnReceive(IAsyncResult ar)
        {
            int bytesProcessed = 0;
            byte[] tempPacket = new byte[1024];

            int byteRead = connectedSocket.EndReceive(ar);
            if (byteRead > 0)
            {
                while (bytesProcessed != byteRead)
                {
                    Array.Copy(receiveBuffer, bytesProcessed, tempPacket, 0, receiveBuffer[bytesProcessed]);
                    Process(tempPacket);
                    bytesProcessed = bytesProcessed + receiveBuffer[bytesProcessed];
                }
            }
            
            connectedSocket.BeginReceive(receiveBuffer, 0,
                BUFFERSIZE, 0, new AsyncCallback(OnReceive), null);
        }

        public void PlayerSelect(int playerID)
        {
            if (connectedAccount != null)
            {
                connectedPlayer = connectedAccount.PlayerLogin(playerID, this);
                Send(new LoginOK());
                Send(new PlayerInfo(connectedPlayer));
                Send(new SetCamera(connectedPlayer, 0x00));
                Send(new Unknown());
            }
        }

        public void UserLogin(string strUser, string strPass)
        {
            Account tmpAcc = Account.Authenticate(strUser, strPass);
            if (tmpAcc != null)
            {
                connectedAccount = tmpAcc;
                connectedAccount.SendPlayerList(this);
            }
            else
            {
                Account.SendLoginError(this);
            }
        }

        public void SendInit()
        {
            Send(new Init(Server.FIRST_KEY, 0x00));
        }

        public void Disconnect()
        {
            Console.WriteLine("Connection for {0} terminated", this.Player.CharacterName);
            return;
        }
    }
}
