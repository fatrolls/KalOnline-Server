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
using System.Collections;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;

using System.Data;
using Mono.Data.SqliteClient;

namespace KalServer
{
    public class KalServ
    {
        static void Main(string[] args)
        {
            try 
            {
                Console.TreatControlCAsInput = false;
                Server server = new Server();
                Console.CancelKeyPress += new ConsoleCancelEventHandler(server.cleanShutdown);
                
                Server.dbCon = new SqliteConnection("URI=file:server.sdb");
                Server.dbCon.Open();

                Console.WriteLine("KalOnline Server Emulator by ingam0r");
                Console.WriteLine("This is pre-alpha... by far not completed");
                Console.WriteLine("Have fun :)");
                Console.WriteLine("-----------------------------------------");
                
                World.LoadMOBs();
                
                Server._aithread = new Thread(AI.AIThread.Run);
                Server._aithread.Priority = ThreadPriority.BelowNormal;
                Server._aithread.Start();
                
                server.Start(); 
            }
            catch (Exception e) 
            { 
                Console.WriteLine(e.Message);
                Console.WriteLine(e.StackTrace);
            }
            finally
            { 
                Console.WriteLine("Server terminated"); 
            }

        }
    }
}
