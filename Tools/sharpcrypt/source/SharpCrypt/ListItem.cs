/*
 * Based on the work of Peter S. Stevens, The Phantom. 
 * 
 * Copyright (c) 2007, Claus J. Jørgensen, TheDeathArt. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 51
 * Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
using System;
using System.Collections.Generic;
using System.Text;

namespace SharpCrypt {
    class ListItem {
        public int Index;
        public string Value;
        public string Content;
        public int Encoding = 0x2F;
        
        public ListItem(int index,string value,byte[] _bytes) {
            this.Index = index;
            this.Value = value;

            byte[] bytes = _bytes;
            
            if(Convert.ToInt32(bytes[0]) != 0xBB) {
                this.Encoding = 0x2F;
            }
            if(Convert.ToInt32(bytes[0]) == 0xBB) {
                this.Encoding = 0x04;
            }
            
            for(int i=0;i<bytes.Length;i++) {
                bytes[i] = SwordCrypt.Crypto.decode(this.Encoding,_bytes[i]);
            }
            Encoding EUC = System.Text.Encoding.GetEncoding(949);           
            Encoding UTF = UTF8Encoding.UTF8;
            byte[] utfBytes = System.Text.Encoding.Convert(EUC,UTF,_bytes);
            this.Content = UTF.GetString(utfBytes);
        }

        public override string ToString() {
            return this.Value;
        }
    }
}
