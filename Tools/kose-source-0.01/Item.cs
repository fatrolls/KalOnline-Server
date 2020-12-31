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
    /// <summary>
    /// Represents an item in the game. Partly deprecated.
    /// </summary>
    public class Item
    {
        private int _dbid;
        private ushort _index;
        private int _anzahl;
        private byte _prefix;
        private int _info;
        private byte _maxendurance;
        private byte _curendurance;
        private byte _setgem;
        private byte _attack;
        private byte _magic;
        private byte _defense;
        private byte _otp;
        private byte _dodge;
        private byte _protect;
        private byte _upgradelevel;
        private byte _upgraderate;

        public int DBID { get { return this._dbid; } set { this._dbid = value; } }
        public ushort Index { get { return this._index; } set { this._index = value; } }
        public byte Prefix { get { return this._prefix; } set { this._prefix = value; } }
        public int Info { get { return this._info; } set { this._info = value; } }
        public int Count { get { return this._anzahl; } set { this._anzahl = value; } }
        public byte MaxEndurance { get { return this._maxendurance; } set { this._maxendurance = value; } }
        public byte CurrentEndurance { get { return this._curendurance; } set { this._curendurance = value; } }
        public byte SetGem { get { return this._setgem; } set { this._setgem = value; } }
        public byte AttackTalis { get { return this._attack; } set { this._attack = value; } }
        public byte MagicTalis { get { return this._magic; } set { this._magic = value; } }
        public byte Defense { get { return this._defense; } set { this._defense = value; } }
        public byte OnTargetPoint { get { return this._otp; } set { this._otp = value; } }
        public byte Dodge { get { return this._dodge; } set { this._dodge = value; } }
        public byte Protect { get { return this._protect; } set { this._protect = value; } }
        public byte EBLevel { get { return this._upgradelevel; } set { this._upgradelevel = value; } }
        public byte EBRate { get { return this._upgraderate; } set { this._upgraderate = value; } }
    }
}
