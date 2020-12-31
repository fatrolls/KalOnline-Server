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
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using Microsoft.DirectX.DirectInput;

namespace SharpGTX {
    public partial class SharpGTX : Form {
        public SharpGTX() {
            InitializeComponent();
        }

        private byte[] DecodeGTX(byte[] bytes) {
            bytes[0] = Convert.ToByte('D');
            bytes[1] = Convert.ToByte('D');
            bytes[2] = Convert.ToByte('S');
            for(int i=7;i<64;i++) {
                bytes[i] = SwordCrypt.Crypto.decode(0x04,bytes[i]);
            }        
            return bytes;        
        }
        
        private byte[] EncodeGTX(byte[] bytes) {
            bytes[0] = Convert.ToByte('K');
            bytes[1] = Convert.ToByte('A');
            bytes[2] = Convert.ToByte('L');
            for(int i=7;i<64;i++) {
                bytes[i] = SwordCrypt.Crypto.encode(0x04,bytes[i]);
            }        
            return bytes;        
        }

        private void SharpGTX_Load(object sender, EventArgs e) {

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
                    listBox1.Items.Add(new ListItem(filename.ToString()));
                }
            }
        }

        private void button3_Click(object sender, EventArgs e) {
            string filename = "";
            progressBar1.Minimum = 0;
            progressBar1.Maximum = listBox1.Items.Count;
            progressBar1.Value   = 0;
            foreach(ListItem item in listBox1.Items) {
                if(Path.GetExtension(item.Path) == ".gtx" || Path.GetExtension(item.Path) == ".GTX") {
                    filename = Path.ChangeExtension(item.Path,"dds");
                    if(textBox1.Text != string.Empty) {
                        if(!Directory.Exists(textBox1.Text)) {
                            MessageBox.Show("Selected output directory does not exists");
                            return;
                        }  
                        filename = textBox1.Text + "/" + Path.GetFileName(filename);
                    }
                    byte[] b = File.ReadAllBytes(item.Path);
                    File.WriteAllBytes(filename,DecodeGTX(b));  
                } else {
                    filename = Path.ChangeExtension(item.Path,"gtx");
                    if(textBox1.Text != string.Empty) {
                        if(!Directory.Exists(textBox1.Text)) {
                            MessageBox.Show("Selected output directory does not exists");
                            return;
                        }  
                        filename = textBox1.Text + "/" + Path.GetFileName(filename);
                    }
                    byte[] b = File.ReadAllBytes(item.Path);
                    File.WriteAllBytes(filename,EncodeGTX(b));  
                }
                progressBar1.Value += 1;
            }
            listBox1.Items.Clear();
            progressBar1.Value = 0;
        }

        private void button1_Click(object sender, EventArgs e) {
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Filter = @"Known Filetypes (*.gtx,*.dds)|*.gtx;*.dds|
                           All Files (*.*)|*.*";
            ofd.Multiselect = true;
            ofd.FileOk += new CancelEventHandler(delegate(object s,CancelEventArgs ce) {
                foreach(string file in ofd.FileNames) {
                    listBox1.Items.Add(new ListItem(file));
                } 
            });
            ofd.ShowDialog();
        }

        private void button4_Click(object sender, EventArgs e) {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            DialogResult dr = fbd.ShowDialog();
            if(dr == DialogResult.OK) {
                textBox1.Text = fbd.SelectedPath;
            }
        }

        private void button2_Click(object sender, EventArgs e) {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            DialogResult dr = fbd.ShowDialog();
            if(dr == DialogResult.OK) {
                foreach(string file in Directory.GetFiles(fbd.SelectedPath)) {
                    listBox1.Items.Add(new ListItem(file));
                }
            }
        }

        private void button5_Click(object sender, EventArgs e) {
            for(int i=(listBox1.SelectedItems.Count-1);i>=0;i--) {
                listBox1.Items.Remove(listBox1.SelectedItems[i]);
            }
        }
    }
}