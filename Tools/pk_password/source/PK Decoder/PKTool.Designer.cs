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
namespace KalOnline {
    partial class PKTool {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if(disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.xorBox = new System.Windows.Forms.TextBox();
            this.hexBox = new System.Windows.Forms.TextBox();
            this.decodeBtn = new System.Windows.Forms.Button();
            this.resultBox = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.encode_result = new System.Windows.Forms.TextBox();
            this.encodeBtn = new System.Windows.Forms.Button();
            this.pw_encode = new System.Windows.Forms.TextBox();
            this.xor_encode = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(95, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(59, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "HEX String";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(18, 25);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(60, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "XOR Value";
            // 
            // xorBox
            // 
            this.xorBox.Location = new System.Drawing.Point(21, 46);
            this.xorBox.Name = "xorBox";
            this.xorBox.Size = new System.Drawing.Size(71, 20);
            this.xorBox.TabIndex = 2;
            this.xorBox.Text = "250";
            // 
            // hexBox
            // 
            this.hexBox.Location = new System.Drawing.Point(98, 46);
            this.hexBox.Name = "hexBox";
            this.hexBox.Size = new System.Drawing.Size(306, 20);
            this.hexBox.TabIndex = 3;
            // 
            // decodeBtn
            // 
            this.decodeBtn.Location = new System.Drawing.Point(21, 72);
            this.decodeBtn.Name = "decodeBtn";
            this.decodeBtn.Size = new System.Drawing.Size(75, 23);
            this.decodeBtn.TabIndex = 4;
            this.decodeBtn.Text = "Decode";
            this.decodeBtn.UseVisualStyleBackColor = true;
            this.decodeBtn.Click += new System.EventHandler(this.decodeBtn_Click);
            // 
            // resultBox
            // 
            this.resultBox.Location = new System.Drawing.Point(21, 101);
            this.resultBox.Name = "resultBox";
            this.resultBox.ReadOnly = true;
            this.resultBox.Size = new System.Drawing.Size(383, 20);
            this.resultBox.TabIndex = 5;
            this.resultBox.Text = "Result";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.resultBox);
            this.groupBox1.Controls.Add(this.decodeBtn);
            this.groupBox1.Controls.Add(this.hexBox);
            this.groupBox1.Controls.Add(this.xorBox);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(443, 145);
            this.groupBox1.TabIndex = 6;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Decode";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.encode_result);
            this.groupBox2.Controls.Add(this.encodeBtn);
            this.groupBox2.Controls.Add(this.pw_encode);
            this.groupBox2.Controls.Add(this.xor_encode);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.label4);
            this.groupBox2.Location = new System.Drawing.Point(12, 173);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(443, 145);
            this.groupBox2.TabIndex = 7;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Encode";
            // 
            // encode_result
            // 
            this.encode_result.Location = new System.Drawing.Point(21, 101);
            this.encode_result.Name = "encode_result";
            this.encode_result.ReadOnly = true;
            this.encode_result.Size = new System.Drawing.Size(383, 20);
            this.encode_result.TabIndex = 5;
            this.encode_result.Text = "Result";
            // 
            // encodeBtn
            // 
            this.encodeBtn.Location = new System.Drawing.Point(21, 72);
            this.encodeBtn.Name = "encodeBtn";
            this.encodeBtn.Size = new System.Drawing.Size(75, 23);
            this.encodeBtn.TabIndex = 4;
            this.encodeBtn.Text = "Encode";
            this.encodeBtn.UseVisualStyleBackColor = true;
            this.encodeBtn.Click += new System.EventHandler(this.encodeBtn_Click);
            // 
            // pw_encode
            // 
            this.pw_encode.Location = new System.Drawing.Point(98, 46);
            this.pw_encode.Name = "pw_encode";
            this.pw_encode.Size = new System.Drawing.Size(306, 20);
            this.pw_encode.TabIndex = 3;
            // 
            // xor_encode
            // 
            this.xor_encode.Location = new System.Drawing.Point(21, 46);
            this.xor_encode.Name = "xor_encode";
            this.xor_encode.Size = new System.Drawing.Size(71, 20);
            this.xor_encode.TabIndex = 2;
            this.xor_encode.Text = "250";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(18, 25);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(60, 13);
            this.label3.TabIndex = 1;
            this.label3.Text = "XOR Value";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(95, 25);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(70, 13);
            this.label4.TabIndex = 0;
            this.label4.Text = "PK Password";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(471, 333);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form1";
            this.Text = "PK Password Encoder/Decoder";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox xorBox;
        private System.Windows.Forms.TextBox hexBox;
        private System.Windows.Forms.Button decodeBtn;
        private System.Windows.Forms.TextBox resultBox;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox encode_result;
        private System.Windows.Forms.Button encodeBtn;
        private System.Windows.Forms.TextBox pw_encode;
        private System.Windows.Forms.TextBox xor_encode;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
    }
}

