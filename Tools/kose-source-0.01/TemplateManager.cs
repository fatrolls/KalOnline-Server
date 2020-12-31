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

namespace KalServer
{
    class TemplateManager
    {
        private static Dictionary<ushort, ItemTemplate> itemTemplates;

        static TemplateManager()
        {
            itemTemplates = new Dictionary<ushort, ItemTemplate>();
            loadItemTemplates();
        }

        public static ItemTemplate getItemTemplate(ushort itemIndex)
        {
            try
            {
                ItemTemplate itemTemplate = itemTemplates[itemIndex];
                return itemTemplate;
            }
            catch (KeyNotFoundException)
            {
                Console.WriteLine("An item whose key doesn't exist got requested");
            }
            return null;
        }

        private static void registerItemTemplate(ItemTemplate itemTemplate)
        {
            try
            {
                itemTemplates.Add(itemTemplate.Index, itemTemplate);
            }
            catch (ArgumentException)
            {
                Console.WriteLine("Duplicate item index detected");
            }
        }

        private static void loadItemTemplates()
        {
            IDbCommand dbCommand = Server.dbCon.CreateCommand();
            dbCommand.CommandText = "SELECT * FROM Items";
            IDataReader dbReader = dbCommand.ExecuteReader();

            Console.WriteLine("Loading item-templates");
            while (dbReader.Read())
            {
                ItemTemplate template = new ItemTemplate();
                template.Index = (ushort)dbReader.GetInt16(0);
                template.Class = (ItemClass)dbReader.GetByte(1);
                template.Subclass = (ItemSubclass)dbReader.GetByte(2);
                template.MinLevel = dbReader.GetByte(3);

                registerItemTemplate(template);
            }
            dbReader.Close();
            dbReader = null;
            dbCommand.Dispose();
            dbCommand = null;
            Console.WriteLine("Item-templates loaded");
        }
    }
}
