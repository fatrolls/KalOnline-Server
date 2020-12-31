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
    class PackageHandler {
        /// <summary>
        /// Opens a kalonline .pk package, and extract the files into memory.
        /// </summary>
        /// <param name="filename">Full filename and path</param>
        public PackageHandler(string filename,SharpCryptForm parentForm) {
            ZipInputStream zipStream = new ZipInputStream(File.OpenRead(filename));
            PasswordPromt promt = new PasswordPromt();
            if(promt.ShowDialog() == DialogResult.OK) {
                zipStream.Password = promt.Password;
                OpenPackageWindow(filename,parentForm,zipStream);
            } 
        }
        
        /// <summary>
        /// Opens a new window that will show the files in the package
        /// and a editor to the right.
        /// </summary>
        /// <param name="filename">Full filename and path</param>
        /// <param name="parentForm">Parent MDI window</param>
        /// <param name="zipStream">Opened ZipStream with the Package</param>
        private void OpenPackageWindow(string filename,SharpCryptForm parentForm,ZipInputStream zipStream) {
            // load files into memory
            List<ListItem> items;
            try {
                items = ListFiles(zipStream);
            } catch(Exception) {
                // if the password were wrong, cancel the operation
                MessageBox.Show(@"Wrong password. Please reopen the file with the correct password");
                zipStream.Close();
                return;
            } 
            zipStream.Close();
            
            // editor content box    
            RichTextBox contentBox = new RichTextBox();
            contentBox.BorderStyle = BorderStyle.None;
            contentBox.Dock     = DockStyle.Fill;
            contentBox.Font     = new Font(
                "Courier New", 9.75F,
                FontStyle.Regular, 
                GraphicsUnit.Point, 
                ((byte)(0))
            );
            contentBox.ImeMode  = ImeMode.HangulFull;
            contentBox.Location = new Point(173, 5);
            contentBox.Size     = new Size(390, 335);
            contentBox.TabIndex = 2;
            contentBox.Text     = "";
            contentBox.WordWrap = false; 
            contentBox.Visible  = false;
            
            // filelist 
            ListBox lb = new ListBox();
            lb.BorderStyle = BorderStyle.None;
            lb.Dock        = DockStyle.Fill;
            lb.FormattingEnabled = true;
            lb.IntegralHeight    = false;
            lb.Location          = new Point(5, 5);
            lb.Size     = new System.Drawing.Size(160, 335);
            lb.TabIndex = 3;
            
            // table layout
            TableLayoutPanel tlp = new TableLayoutPanel();
            tlp.CellBorderStyle  = TableLayoutPanelCellBorderStyle.Inset;
            tlp.ColumnCount      = 2;
            tlp.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 166F));
            tlp.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tlp.Controls.Add(lb, 0, 0);
            tlp.Controls.Add(contentBox, 1, 0);
            tlp.Dock     = DockStyle.Fill;
            tlp.Location = new Point(3, 3);
            tlp.RowCount = 1;
            tlp.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tlp.Size     = new System.Drawing.Size(568, 345);
            tlp.TabIndex = 3;            
            
            // editor window
            EditorWindow window = new EditorWindow();
            window.Package   = filename;
            window.Text      = Path.GetFileName(filename); 
            window.textBox   = contentBox;
            window.listBox   = lb;
            window.password  = zipStream.Password;
            window.MdiParent = parentForm;
            window.Controls.Add(tlp);
            window.Show(); 
            window.IsPackage = true;  
            window.Encoding  = items[0].Encoding;
            window.instance  = this;
            
            // ListItem index change event
            lb.SelectedIndexChanged += new EventHandler(
                delegate(Object sender,EventArgs e) {
                    ItemSelectHandler(lb,window);
                }
            );
            
            // list items, threaded because some files (e.pk) is very huge
            lb.Enabled = false;
            BackgroundWorker bw = new BackgroundWorker();
            bw.DoWork += new DoWorkEventHandler(
                delegate(object sender,DoWorkEventArgs e) {
                    parentForm.InvokeDelegate(delegate() {
                        parentForm.statusLabel.Visible = true;
                        parentForm.statusLabel.Text = "Loading " + Path.GetFileName(filename) + "...";
                        lb.Items.AddRange(items.ToArray());
                        lb.Enabled = true;
                        parentForm.statusLabel.Text = "Loading...";
                        parentForm.statusLabel.Visible = false;
                    });
                }
            ); 
            bw.RunWorkerAsync();
        }        
        
        private List<ListItem> ListFiles(ZipInputStream zipStream) {
            List<ListItem> items = new List<ListItem>();
            ZipEntry file;
            int idx = 0;           
            while((file = zipStream.GetNextEntry()) != null) {
                byte[] data      = new byte[2048];
                List<byte> input = new List<byte>();
                while(true) {
                    int size = zipStream.Read(data, 0, data.Length);
                    if(size <= 0) { 
                        break;
                    }
                    for(int i=0;i<size;i++) {
                        input.Add(data[i]);
                    }
                }
                items.Add(new ListItem(idx,file.Name,input.ToArray())); 
                idx++; 
            }
            return items;
        }
        
        public static void Save(EditorWindow window) {
             FileMode fm = FileMode.CreateNew;
             if(File.Exists(window.Package)) {
                 fm = FileMode.Truncate;
             }
             ZipOutputStream s = new ZipOutputStream(File.Open(window.Package,fm));
             
             s.SetLevel(0);  
             s.Password = window.password;
             
             ((ListItem)window.listBox.Items[window.SelectedItem]).Content = window.textBox.Text;
             
             Encoding EUC = Encoding.GetEncoding(949);           
             Encoding UTF = UTF8Encoding.UTF8;
             ZipEntry entry;
             
             ListItem[] items = new ListItem[window.listBox.Items.Count];
             window.listBox.Items.CopyTo(items,0);
             
             foreach(ListItem item in items) {
                 entry = new ZipEntry(item.ToString());
                 entry.DateTime = DateTime.Now;      
                 
                 byte[] buffer = UTF.GetBytes(item.Content);
                 buffer = Encoding.Convert(UTF,EUC,buffer);
                 
                 for(int i=0;i<buffer.Length;i++) {
                     buffer[i] = Convert.ToByte(SwordCrypt.Crypto.encode(window.Encoding,buffer[i]));
                 }
                 
                 s.PutNextEntry(entry); 
                 s.Write(buffer,0,buffer.Length);
             }                      
             s.Finish();
             s.Close();
        }
        
        private void ItemSelectHandler(ListBox listBox,EditorWindow window) {
            window.textBox.Visible = true;
            SharpCryptForm parentForm = (SharpCryptForm)window.MdiParent;
            if(window.SelectedItem != -1) {
                ((ListItem)listBox.Items[window.SelectedItem]).Content = window.textBox.Text;
            }
            window.SelectedItem = listBox.SelectedIndex;
            ListItem item = (ListItem)listBox.Items[listBox.SelectedIndex];
            window.textBox.Text = item.Content;
            // reset formatting
            window.textBox.SelectAll();
            window.textBox.SelectionFont = new Font(
                "Courier New", 9.75F,
                FontStyle.Regular, 
                GraphicsUnit.Point, 
                ((byte)(0))
            );
            window.textBox.DeselectAll();
            window.textBox.SelectionStart = 0;
            // set title
            listBox.Parent.Parent.Text = Path.GetFileName(window.Package) 
                                         + " - " + item.Value;                                                    
        }
    
    }
}
