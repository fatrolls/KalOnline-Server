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
using System.Data;
using KalServer.Packets;

namespace KalServer
{
    public class Account
    {
        /* The private members are only set when the user has been authenticated */
        private int dbID;
        private string strUsername;
        private string strPassword;

        /* An instance of this class can only be created with a valid username and password
         * via the static Authenticate-method */
        private Account() { }

        /* Creates an instance of Account when a player gets successfully authenticated.
         * If the supplied username and password don't fit each other then null is returned */
        public static Account Authenticate(string strUsername, string strPassword)
        {
            int dbID = -1;
            bool authenticated = false;

            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT * FROM [Login] WHERE [Name]='" + strUsername + "'";
            IDataReader dbReader = dbCommand.ExecuteReader();

            if (dbReader.Read() == false)
            {
                // there is no dataset to be read.
                authenticated = false;
            }
            else if ((dbReader.GetString(1) == strUsername) && (dbReader.GetString(2) == strPassword))
            {
                // since a username can only exist once it is okay to read the first
                // dataset only
                dbID = dbReader.GetInt32(0);
                authenticated = true;
            }
            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;

            if (authenticated)
            {
                Account tmpAcc = new Account();
                tmpAcc.dbID = dbID;
                tmpAcc.strUsername = strUsername;
                tmpAcc.strPassword = strPassword;
                return tmpAcc;
            }
            else return null;
        }
        
        /* Sends a list of characters that belong to this account to the client */
        public void SendPlayerList(Connection pConn)
        {
            List<PlayerListItem> pList = new List<PlayerListItem>();
            PlayerListItem pListItem;
           
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT * FROM [Player] WHERE [UID] = " + dbID;
            IDataReader dbReader = dbCommand.ExecuteReader();

            while (dbReader.Read())
            {
                pListItem = new PlayerListItem();
                pListItem.lstItems = new List<ushort>();

                pListItem.dbID = dbReader.GetInt32(1);
                pListItem.strName = dbReader.GetString(2);
                pListItem.bClass = dbReader.GetByte(11);
                pListItem.bLevel = dbReader.GetByte(13);

                pListItem.bStrength = dbReader.GetByte(3);
                pListItem.bHealth = dbReader.GetByte(4);
                pListItem.bIntelli = dbReader.GetByte(5);
                pListItem.bWisdom = dbReader.GetByte(6);
                pListItem.bAgility = dbReader.GetByte(7);

                pListItem.bFace = dbReader.GetByte(14);
                pListItem.bHair = dbReader.GetByte(15);

                IDbCommand dbInnerCommand = Server.dbCon.CreateCommand();
                dbInnerCommand.CommandText = "SELECT [Item] FROM [Inventory] WHERE " +
                    "([Info] & 1) AND ([PlayerID] = " + pListItem.dbID + ")";
                IDataReader dbInnerReader = dbInnerCommand.ExecuteReader();

                while (dbInnerReader.Read())
                {
                    pListItem.lstItems.Add((ushort)dbInnerReader.GetInt16(0));
                }
                dbInnerReader.Close();
                dbInnerReader = null;
                dbInnerCommand.Dispose();
                dbInnerCommand = null;

                pList.Add(pListItem);
            }
            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;

            pConn.Send(new PlayerList(pList));

            return;
        }

        /* Sends a login-error message to the client */
        public static void SendLoginError(Connection pConn)
        {
            pConn.Send(new LoginError(LOGIN_ERROR.WRONGID));
            return;
        }

        /* Gets called when the user selects a character to play with */
        public Player PlayerLogin(int pID, Connection pConn)
        {
            // Check if the player-ID belongs to this account
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT [UID] FROM [Player] WHERE [PID] = " + pID;
            IDataReader dbReader = dbCommand.ExecuteReader();

            if (dbReader.Read() == false) return null;
            else
            {
                Player newPlayer = new Player(pID);
                newPlayer.Connection = pConn;
                return newPlayer;
            }
        }
    }
}
