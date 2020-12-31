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
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using System.Threading;

namespace SharpCrypt {
    public partial class SharpCryptForm : Form {
        /// <summary>
        /// Contain the list of open files in the MDI
        /// </summary>
        public List<string> openFiles = new List<string>();
        
        /// <summary>
        /// Initialize SharpCrypt :-)
        /// </summary>
        public SharpCryptForm(string[] args) {
            InitializeComponent();
            if(args.Length > 0) {
                if(Path.GetExtension(args[0]) == ".pk") {
                    PackageHandler handler = new PackageHandler(args[0],this);
                } else {
                    FileHandler handler = new FileHandler(args[0],this);
                }    
            }
        }
            
        /// <summary>
        /// Drag Enter, part of Drag&Drop 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DragEnterHandler(object sender,DragEventArgs e) {
            if(e.Data.GetDataPresent(DataFormats.FileDrop)) {
                e.Effect = DragDropEffects.Copy;
            } else {
                e.Effect = DragDropEffects.None;    
            }
        }    
        
        /// <summary>
        /// Drag and Drop Handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DragDropHandler(object sender,DragEventArgs e) {
            Array a = (Array)e.Data.GetData(DataFormats.FileDrop);
            if(a != null) {
                foreach(object filename in a) {
                    // TODO: Change this to check content, rather than extension
                    if(Path.GetExtension(filename.ToString()) == ".pk") {
                        PackageHandler handler = new PackageHandler(filename.ToString(),this);
                    } else {
                        FileHandler handler = new FileHandler(filename.ToString(),this);
                    }
                }
            }
        }
            
        // delegate used for threading UI
        public delegate void UIDelegate();
        
        /// <summary>
        /// Invokes a UIDelegate. 
        /// This is used for multithreading the UI components
        /// </summary>
        /// <param name="method"></param>
        public void InvokeDelegate(UIDelegate method) {
            try {
                Invoke(method); 
            } catch(Exception) {
            }
        }
    }
}