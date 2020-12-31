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
using System.Net.Sockets;
using System.Net;
using System.Threading;
using Mono.Data.SqliteClient;
using System.Data;

using KalServer.Packets;

namespace KalServer
{
    class Server
    {
        public const int SERVER_PORT = 30001;
        public const byte FIRST_KEY = 56;

        public static Thread _aithread = null;
        public static ManualResetEvent allDone = new ManualResetEvent(false);
        public static Random rand = new Random();
        public static IDbConnection dbCon;
        public static PacketHandlers packetHandles = new PacketHandlers();

        public List<Connection> connectionList = new List<Connection>();

        public void cleanShutdown(object sender, ConsoleCancelEventArgs e)
        {
            // Bring the server into a defined state before the program ends
            Console.WriteLine("Server is being shut down...");
            foreach (Connection pConn in connectionList)
            {
                pConn.Disconnect();
            }
        }

        public void Start()
        {
            IPEndPoint localEndPoint = new IPEndPoint(IPAddress.Any, SERVER_PORT);
            Socket listener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

            try
            {
                listener.Bind(localEndPoint);
                listener.Listen(5);

                while (true)
                {
                    allDone.Reset();
                    Console.WriteLine("Waiting for connection...");
                    listener.BeginAccept(new AsyncCallback(this.AcceptCallback), listener);
                    allDone.WaitOne();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public void AcceptCallback(IAsyncResult ar)
        {
            allDone.Set();
            Socket listener = (Socket)ar.AsyncState;
            Socket handler = listener.EndAccept(ar);

            Connection netState = new Connection(handler);
            //handler.BeginReceive(netState.Buffer, 0,
            //    Connection.BUFFERSIZE, 0, new AsyncCallback(ReadCallBack), netState);
            handler.BeginReceive(netState.Buffer, 0, 
                Connection.BUFFERSIZE, 0, new AsyncCallback(netState.OnReceive), null);
        }
    }
}
