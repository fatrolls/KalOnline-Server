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
using System.Collections;
using System.Collections.Generic;
using System.Text;

using System.Data;
using Mono.Data.SqliteClient;

namespace KalServer
{
    public class Inventory : IEnumerable
    {
        private List<Item> _itemlist;

        private Item _weapon = null;
        private Item _shield = null;
        private Item _chest = null;
        private Item _helmet = null;
        private Item _gloves = null;
        private Item _boots = null;
        private Item _shorts = null;

        public int ItemCount { get { return this._itemlist.Count; } }
        public Item Weapon { get { return this._weapon; } }
        public Item Shield { get { return this._shield; } }
        public Item Chest { get { return this._chest; } }
        public Item Helmet { get { return this._helmet; } }
        public Item Gloves { get { return this._gloves; } }
        public Item Boots { get { return this._boots; } }
        public Item Shorts { get { return this._shorts; } }

        public Inventory(int PlayerDBID)
        {
            Item tempItem;
            ItemTemplate template;

            this._itemlist = new List<Item>();
            
            // Load inventory from database
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT * FROM [Inventory] WHERE [PlayerID] = " + PlayerDBID;
            IDataReader dbReader = dbCommand.ExecuteReader();

            while (dbReader.Read())
            {
                tempItem = new Item();
                tempItem.DBID = dbReader.GetInt32(0);
                tempItem.Index = (ushort)dbReader.GetInt16(2);
                tempItem.Count = dbReader.GetInt32(3);
                tempItem.Prefix = dbReader.GetByte(4);
                tempItem.Info = dbReader.GetInt32(5);
                tempItem.MaxEndurance = dbReader.GetByte(6);
                tempItem.CurrentEndurance = dbReader.GetByte(7);
                tempItem.SetGem = dbReader.GetByte(8);
                tempItem.AttackTalis = dbReader.GetByte(9);
                tempItem.MagicTalis = dbReader.GetByte(10);
                tempItem.Defense = dbReader.GetByte(11);
                tempItem.OnTargetPoint = dbReader.GetByte(12);
                tempItem.Dodge = dbReader.GetByte(13);
                tempItem.Protect = dbReader.GetByte(14);
                tempItem.EBLevel = dbReader.GetByte(15);
                tempItem.EBRate = dbReader.GetByte(16);

                template = TemplateManager.getItemTemplate(tempItem.Index);
                if ((template.Class == ItemClass.Weapon) && (tempItem.Info == 1))
                    this._weapon = tempItem;

                if ((template.Class == ItemClass.Defense) && (tempItem.Info == 1))
                {
                    switch (template.Subclass)
                    {
                        case ItemSubclass.Chest:
                            this._chest = tempItem;
                            break;

                        case ItemSubclass.Helmet:
                            this._helmet = tempItem;
                            break;

                        case ItemSubclass.Gloves:
                            this._gloves = tempItem;
                            break;

                        case ItemSubclass.Boots:
                            this._boots = tempItem;
                            break;

                        case ItemSubclass.Shorts:
                            this._shorts = tempItem;
                            break;

                        case ItemSubclass.Shield:
                            this._shield = tempItem;
                            break;
                    }
                }

                this.AddItem(tempItem);
            }
            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;
        }

        public IEnumerator GetEnumerator()
        {
            return this._itemlist.GetEnumerator();
        }

        public void AddItem(Item item)
        {
            _itemlist.Add(item);
        }

        public void DeleteItem(Item item)
        {
            _itemlist.Remove(item);
        }

        public ushort[] GetWornItems()
        {
            byte inserted  =0;
            ushort[] temp = new ushort[8];
            foreach (Item i in this._itemlist)
            {
                if ((i.Info & 1) == 1)
                {
                    temp[inserted] = i.Index;
                    inserted++;
                }
            }
            if (inserted != 7)
            {
                for (int i = inserted; i < 8; i++) temp[i] = 0;
            }
            return temp;
        }
    }
}
