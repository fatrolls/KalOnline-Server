/*
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
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace KalOnline {
    public partial class PKTool : Form {
        public PKTool() {
            InitializeComponent();
        }

        private void decodeBtn_Click(object sender, EventArgs e) {
            int xor      = Int32.Parse(xorBox.Text);
            string input = hexBox.Text;

            Regex  match  = new Regex(@"(?:%|\\x|)([a-fA-F0-9]{2})");
            string result = ""; 
            uint uiHex    = 0;
            if(match.IsMatch(input)) {
                MatchCollection matches = match.Matches(input);
                foreach(Match m in matches) {
                    uiHex = System.Convert.ToUInt32(m.ToString(), 16);
                    result += (char)(xor ^ uiHex);
                }
            }
            resultBox.Text = result;
        }

        private void encodeBtn_Click(object sender, EventArgs e) {
            int xor      = Int32.Parse(xor_encode.Text);
            string input = pw_encode.Text;
            string encoded = "";
            int c = 1;
            foreach(char i in input) {
                encoded += String.Format("{0:x}",(xor ^ i));
                if(c % 2 == 0) {
                    encoded += " ";
                }
                c++;
            }
            encoded = encoded.ToUpper();

            encode_result.Text = encoded;
        }
    }
}