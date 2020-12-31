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

namespace SwordCrypt {
    public class Crypto {
         public const int CLUSTER_MAX = 0x3F;
         
         public static byte encode(int key,byte b) {
             return Crypto.crypt(SwordCrypt.Crypt.EncodeTable,key,b);
         }
         
         public static byte decode(int key,byte b) {    
             return Crypto.crypt(SwordCrypt.Crypt.DecodeTable,key,b);
         }
         
         public static byte crypt(int[] table,int key,byte b) {
             key &= Crypto.CLUSTER_MAX;
             key <<= 8;     
             
             return Convert.ToByte(table[key + b]);
         }
    }
}
