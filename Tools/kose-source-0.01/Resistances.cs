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
			
namespace KalServer
{
    public class Resistances
    {
        private byte _Fresi = 10;
        private byte _Iresi = 10;
        private byte _Lresi = 10;
        private byte _Cresi = 25;
        private byte _NEresi = 29;

        public byte Fire { get { return this._Fresi; } set { this._Fresi = value; } }
        public byte Light { get { return this._Lresi; } set { this._Lresi = value; } }
        public byte Ice { get { return this._Iresi; } set { this._Iresi = value; } }
        public byte Curse { get { return this._Cresi; } set { this._Cresi = value; } }
        public byte NonElemental { get { return this._NEresi; } set { this._NEresi = value; } }
    }
}
