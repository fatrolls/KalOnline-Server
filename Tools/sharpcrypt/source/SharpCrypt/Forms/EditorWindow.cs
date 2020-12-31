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
using System.Windows.Forms;
using System.Threading;

namespace SharpCrypt {
    class EditorWindow : Form {
        public string Filename = "";
        public string Package  = "";
        public bool IsPackage  = false;
        public bool Changed    = false; 
        public RichTextBox textBox;
        public int Encoding = 0x2F;
        public int SelectedItem = -1;
        public ListBox listBox;
        public string password;
        public PackageHandler instance;
    }
}
