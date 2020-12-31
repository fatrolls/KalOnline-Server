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

namespace KalServer
{
    public enum ItemClass
    {
        Weapon = 1,
        Defense = 2,
        General = 4,
        Ornament = 8,
        Quest = 16
    }

    public enum ItemSubclass
    {
        Sword = 1,
        Stick = 2,
        Bow = 4,
        Chest = 1,
        Helmet = 2,
        Gloves = 4,
        Boots = 8,
        Shorts = 16,
        Shield = 32
    }

    public class ItemTemplate
    {
        private ushort _index;
        private ItemClass _class;
        private ItemSubclass _subclass;
        private byte _minlevel;

        public ushort Index { get { return this._index; } set { this._index = value; } }
        public ItemClass Class { get { return this._class; } set { this._class = value; } }
        public ItemSubclass Subclass { get { return this._subclass; } set { this._subclass = value; } }
        public byte MinLevel { get { return this._minlevel; } set { this._minlevel = value; } }
    }
}
