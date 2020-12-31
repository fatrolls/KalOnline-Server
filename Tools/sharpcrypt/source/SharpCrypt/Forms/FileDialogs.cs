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
        
        private void openToolStripMenuItem_Click(object sender, EventArgs e) {
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Filter = @"Known Filetypes (*.dat,*.pk)|*.dat;*.pk|
                           All Files (*.*)|*.*";
            ofd.FilterIndex = 1;
            ofd.FileOk += new CancelEventHandler(
                delegate(object s, CancelEventArgs a) {
                    if(ofd.FileName != "") {
                        // TODO: Change this to check content, rather than extension
                        if(Path.GetExtension(ofd.FileName) == ".pk") {
                            PackageHandler handler = new PackageHandler(ofd.FileName,this);
                        } else {
                            FileHandler handler = new FileHandler(ofd.FileName,this);
                        }
                    }
                }
            );
            ofd.ShowDialog();
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e) {
            EditorWindow window = (EditorWindow)this.ActiveMdiChild;
            SaveFileDialog sfd = new SaveFileDialog();
            if(window.IsPackage) {
                sfd.Filter = "Package Files (*.pk)|*.pk|All files (*.*)|*.*" ;
            } else {
                sfd.Filter = "Data Files (*.dat)|*.dat|All files (*.*)|*.*" ;
            }
            sfd.FilterIndex = 1;
            // "Save As" handling
            sfd.FileOk += new CancelEventHandler(
                delegate(object s, CancelEventArgs a) {
                    if(sfd.FileName != "") {
                        // find active window
                        window.Text = Path.GetFileName(sfd.FileName);
                        // type check
                        if(Path.GetExtension(sfd.FileName) == ".pk") {
                            // set new filename
                            window.Package = sfd.FileName;
                            PackageHandler.Save(window);
                        } else {
                            // set new filename
                            window.Filename = sfd.FileName;
                            FileHandler.Save(window);
                        }
                    }
                }
            );
            sfd.ShowDialog();            
        }
        
        private void saveToolStripMenuItem_Click(object sender, EventArgs e) {
            // find active window
            EditorWindow window = (EditorWindow)this.ActiveMdiChild;
            if(window.IsPackage) {
                PackageHandler.Save(window);
            } else {
                FileHandler.Save(window);
            }   
        }    
    }
}
