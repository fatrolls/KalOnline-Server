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
    class FileHandler {
        
        /// <summary>
        /// Opens a .dat file in Window inside a MDI
        /// </summary>
        /// <param name="filename">Full path to the .dat file that is being opened</param>
        /// <param name="parentForm">The MDI Container Window</param>
        public FileHandler(string filename,SharpCryptForm parentForm) {
            // check about file allready is open
            if(parentForm.openFiles.Contains(filename)) {
                return;
            }
            parentForm.openFiles.Add(filename);
            
            // editor box
            RichTextBox contentBox = new RichTextBox();
            contentBox.BorderStyle = BorderStyle.None;
            contentBox.Dock = DockStyle.Fill;
            contentBox.Font = new Font(
                "Courier New", 9.75F,
                FontStyle.Regular, 
                GraphicsUnit.Point, 
                ((byte)(0))
            );
            contentBox.ImeMode  = ImeMode.HangulFull;
            contentBox.Location = new Point(173, 5);
            contentBox.Size     = new Size(390, 335);
            contentBox.TabIndex = 2;
            contentBox.WordWrap = false; 
            
            // editor window
            EditorWindow window = new EditorWindow();
            window.Filename  = filename;
            window.Text      = Path.GetFileName(filename); 
            window.MdiParent = parentForm;
            window.Controls.Add(contentBox);
            window.textBox   = contentBox;
            window.Show();
            window.FormClosing += new FormClosingEventHandler(WindowClosingHandler);
            
            // set the content 
            contentBox.Text = OpenFile(filename,window);
            // set the selection
            contentBox.SelectionStart = 0;
            // reset formatting
            contentBox.SelectAll();
            contentBox.SelectionFont = new Font(
                "Courier New", 9.75F,
                FontStyle.Regular, 
                GraphicsUnit.Point, 
                ((byte)(0))
            );
            contentBox.DeselectAll();
            contentBox.SelectionStart = 0;
            
            // when the text is changed, set the windows changed
            // so the user is asked to save if they try and close the window.
            contentBox.TextChanged += new EventHandler(
                delegate(object s,EventArgs a) { 
                    window.Changed = true; 
                }
            );
        }
        
        /// <summary>
        /// FormClosing handler to check about the window needs saving.
        /// </summary>
        /// <param name="sender">EditorWindow</param>
        /// <param name="e"></param>
        public static void WindowClosingHandler(object sender,FormClosingEventArgs e) {
            DialogResult saveDialog;
            EditorWindow window = (EditorWindow)sender;
            if(window.Changed) {
                saveDialog = MessageBox.Show(
                    "The content been changed. Save changes?",
                    "Warning",
                    MessageBoxButtons.YesNoCancel,
                    MessageBoxIcon.Warning
                );
                if(saveDialog == DialogResult.Cancel) { 
                    e.Cancel = true;     
                    return;
                }
                if(saveDialog == DialogResult.Yes) {
                    FileHandler.Save((EditorWindow)sender);   
                }
            }
            SharpCryptForm f = (SharpCryptForm)window.MdiParent;
            f.openFiles.Remove(window.Filename);
        }
        
        /// <summary>
        /// Opens a kalonline .dat file, and return it's content
        /// </summary>
        /// <param name="filename">Full path to the .dat file that is being opened</param>
        /// <returns></returns>
        private string OpenFile(string filename,EditorWindow window) {
            Encoding EUC  = Encoding.GetEncoding(949);           
            Encoding UTF  = UTF8Encoding.UTF8;
            byte[] bytes  = File.ReadAllBytes(filename);
            // detect encoding
            int openKey = 0x2F;
            if(Convert.ToInt32(bytes[0]) == 0xBB) {
                openKey = 0x04;
            }
            // decode
            for(int i=0;i<bytes.Length;i++) {
                bytes[i] = SwordCrypt.Crypto.decode(openKey,bytes[i]);
            }
            window.Encoding = openKey;
            // convert from korean to unicode
            byte[] newBytes = Encoding.Convert(EUC,UTF,bytes);
            // return result
            return UTF.GetString(newBytes);        
        }
        
        /// <summary>
        /// Creates a empty editor window.
        /// </summary>
        /// <param name="parentForm">The MDI Container Window</param>
        public static void NewFileWindow(Form parentForm) {
            // editor content box
            RichTextBox contentBox = new RichTextBox();
            contentBox.BorderStyle = BorderStyle.None;
            contentBox.Dock = DockStyle.Fill;
            contentBox.Font = new Font(
                "Courier New", 9.75F,
                FontStyle.Regular, 
                GraphicsUnit.Point, 
                ((byte)(0))
            );
            contentBox.ImeMode  = ImeMode.HangulFull;
            contentBox.Location = new Point(173, 5);
            contentBox.Size     = new Size(390, 335);
            contentBox.TabIndex = 2;
            contentBox.WordWrap = false; 
            contentBox.SelectionStart = 0;

            // window
            EditorWindow window = new EditorWindow();
            window.Filename  = "";
            window.Text      = "Untitled";
            window.MdiParent = parentForm;
            window.Controls.Add(contentBox);
            window.textBox = contentBox;
            window.FormClosing += new FormClosingEventHandler(FileHandler.WindowClosingHandler);
            window.Show(); 
            
            // when the text is changed, set the windows changed
            // so the user is asked to save if they try and close the window.
            contentBox.TextChanged += new EventHandler(
                delegate(object s,EventArgs a) { 
                    window.Changed = true; 
                }
            );
        }
        
        /// <summary>
        /// Saves a file to it's current location, or ask for location, 
        /// if the location is not known.
        /// </summary>
        /// <param name="window">The active MDI child window</param>
        public static void Save(EditorWindow window) {
            // if the window does not contain a filename
            // ask the user where to save the file 
            if(window.Filename == String.Empty) {
                SaveFileDialog svd = new SaveFileDialog();
                svd.Filter = @"Data Files (*.dat)|*.dat|
                                           All files (*.*)|*.*";
                svd.FilterIndex = 1;
                svd.ShowDialog(); 
                // set window filename to the new location
                if(svd.FileName != "") {
                    window.Filename = svd.FileName;
                    window.Text     = Path.GetFileName(svd.FileName);
                }
            }
            // encode back to korean
            Encoding EUC = Encoding.GetEncoding(949);           
            Encoding UTF = UTF8Encoding.UTF8;
            byte[] bytes = UTF.GetBytes(window.textBox.Text);
            bytes = Encoding.Convert(UTF,EUC,bytes);
            // encode using phantom's crypto table
            List<byte> output = new List<byte>();
            foreach(byte b in bytes) {
                output.Add(
                    Convert.ToByte(SwordCrypt.Crypto.encode(window.Encoding,b))
                );
            }     
            // write to file
            File.WriteAllBytes(window.Filename,output.ToArray());
            // the window is not changed compared to the orginal
            // and thus the change variable must be set to false again.
            window.Changed = false;
        }
    }
}
