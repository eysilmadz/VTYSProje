namespace OtelOtomasyonuDBProje
{
    partial class OtelYoneticiForm
    {
        /// <summary>
        ///Gerekli tasarımcı değişkeni.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///Kullanılan tüm kaynakları temizleyin.
        /// </summary>
        ///<param name="disposing">yönetilen kaynaklar dispose edilmeliyse doğru; aksi halde yanlış.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer üretilen kod

        /// <summary>
        /// Tasarımcı desteği için gerekli metot - bu metodun 
        ///içeriğini kod düzenleyici ile değiştirmeyin.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OtelYoneticiForm));
            this.Panel = new System.Windows.Forms.Panel();
            this.txtyoneticiNum = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.btnKaydetOda = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.dataGridView2 = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.btnMusteri = new System.Windows.Forms.Button();
            this.btnOdaRezervasyon = new System.Windows.Forms.Button();
            this.btnOtelYonetici = new System.Windows.Forms.Button();
            this.btnPersonel = new System.Windows.Forms.Button();
            this.lblBBaslik = new System.Windows.Forms.Label();
            this.btnYoneticiAra = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.dataGridView3 = new System.Windows.Forms.DataGridView();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.Panel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView3)).BeginInit();
            this.SuspendLayout();
            // 
            // Panel
            // 
            this.Panel.BackColor = System.Drawing.Color.AliceBlue;
            this.Panel.Controls.Add(this.btnYoneticiAra);
            this.Panel.Controls.Add(this.label3);
            this.Panel.Controls.Add(this.dataGridView3);
            this.Panel.Controls.Add(this.textBox1);
            this.Panel.Controls.Add(this.label4);
            this.Panel.Controls.Add(this.txtyoneticiNum);
            this.Panel.Controls.Add(this.label8);
            this.Panel.Controls.Add(this.button1);
            this.Panel.Controls.Add(this.btnKaydetOda);
            this.Panel.Controls.Add(this.label2);
            this.Panel.Controls.Add(this.dataGridView2);
            this.Panel.Controls.Add(this.label1);
            this.Panel.Controls.Add(this.dataGridView1);
            this.Panel.Font = new System.Drawing.Font("Consolas", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.Panel.Location = new System.Drawing.Point(272, 53);
            this.Panel.Name = "Panel";
            this.Panel.Size = new System.Drawing.Size(1125, 671);
            this.Panel.TabIndex = 7;
            this.Panel.Paint += new System.Windows.Forms.PaintEventHandler(this.Panel_Paint);
            // 
            // txtyoneticiNum
            // 
            this.txtyoneticiNum.Location = new System.Drawing.Point(945, 248);
            this.txtyoneticiNum.Name = "txtyoneticiNum";
            this.txtyoneticiNum.Size = new System.Drawing.Size(172, 34);
            this.txtyoneticiNum.TabIndex = 100;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label8.Location = new System.Drawing.Point(731, 259);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(208, 23);
            this.label8.TabIndex = 99;
            this.label8.Text = "Yönetici Numarası:";
            // 
            // button1
            // 
            this.button1.BackColor = System.Drawing.Color.AliceBlue;
            this.button1.Font = new System.Drawing.Font("Consolas", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.button1.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.button1.Location = new System.Drawing.Point(932, 315);
            this.button1.Margin = new System.Windows.Forms.Padding(4);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(180, 39);
            this.button1.TabIndex = 98;
            this.button1.Text = "Yönetici Güncelle";
            this.button1.UseVisualStyleBackColor = false;
            // 
            // btnKaydetOda
            // 
            this.btnKaydetOda.BackColor = System.Drawing.Color.AliceBlue;
            this.btnKaydetOda.Font = new System.Drawing.Font("Consolas", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.btnKaydetOda.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.btnKaydetOda.Location = new System.Drawing.Point(744, 315);
            this.btnKaydetOda.Margin = new System.Windows.Forms.Padding(4);
            this.btnKaydetOda.Name = "btnKaydetOda";
            this.btnKaydetOda.Size = new System.Drawing.Size(180, 39);
            this.btnKaydetOda.TabIndex = 97;
            this.btnKaydetOda.Text = "Yönetici Sil";
            this.btnKaydetOda.UseVisualStyleBackColor = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label2.Location = new System.Drawing.Point(26, 201);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(208, 23);
            this.label2.TabIndex = 82;
            this.label2.Text = "Yönetici Bilgileri";
            // 
            // dataGridView2
            // 
            this.dataGridView2.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView2.BackgroundColor = System.Drawing.SystemColors.Control;
            this.dataGridView2.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView2.Location = new System.Drawing.Point(20, 227);
            this.dataGridView2.Name = "dataGridView2";
            this.dataGridView2.RowHeadersWidth = 51;
            this.dataGridView2.RowTemplate.Height = 24;
            this.dataGridView2.Size = new System.Drawing.Size(696, 181);
            this.dataGridView2.TabIndex = 81;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label1.Location = new System.Drawing.Point(26, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(164, 23);
            this.label1.TabIndex = 80;
            this.label1.Text = "Otel Bilgileri";
            // 
            // dataGridView1
            // 
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.BackgroundColor = System.Drawing.SystemColors.Control;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(20, 54);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.RowTemplate.Height = 24;
            this.dataGridView1.Size = new System.Drawing.Size(1093, 92);
            this.dataGridView1.TabIndex = 79;
            // 
            // btnMusteri
            // 
            this.btnMusteri.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnMusteri.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnMusteri.Location = new System.Drawing.Point(20, 280);
            this.btnMusteri.Margin = new System.Windows.Forms.Padding(4);
            this.btnMusteri.Name = "btnMusteri";
            this.btnMusteri.Size = new System.Drawing.Size(228, 55);
            this.btnMusteri.TabIndex = 11;
            this.btnMusteri.Text = "Müşteri Bilgileri";
            this.btnMusteri.UseVisualStyleBackColor = false;
            this.btnMusteri.Click += new System.EventHandler(this.btnMusteri_Click);
            // 
            // btnOdaRezervasyon
            // 
            this.btnOdaRezervasyon.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnOdaRezervasyon.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnOdaRezervasyon.Location = new System.Drawing.Point(20, 217);
            this.btnOdaRezervasyon.Margin = new System.Windows.Forms.Padding(4);
            this.btnOdaRezervasyon.Name = "btnOdaRezervasyon";
            this.btnOdaRezervasyon.Size = new System.Drawing.Size(228, 55);
            this.btnOdaRezervasyon.TabIndex = 9;
            this.btnOdaRezervasyon.Text = "Oda/Rezervasyon Bilgileri";
            this.btnOdaRezervasyon.UseVisualStyleBackColor = false;
            this.btnOdaRezervasyon.Click += new System.EventHandler(this.btnOdaRezervasyon_Click);
            // 
            // btnOtelYonetici
            // 
            this.btnOtelYonetici.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnOtelYonetici.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnOtelYonetici.Location = new System.Drawing.Point(20, 406);
            this.btnOtelYonetici.Margin = new System.Windows.Forms.Padding(4);
            this.btnOtelYonetici.Name = "btnOtelYonetici";
            this.btnOtelYonetici.Size = new System.Drawing.Size(228, 55);
            this.btnOtelYonetici.TabIndex = 10;
            this.btnOtelYonetici.Text = "Otel/Yönetici Bilgileri";
            this.btnOtelYonetici.UseVisualStyleBackColor = false;
            this.btnOtelYonetici.Click += new System.EventHandler(this.btnOtelYonetici_Click);
            // 
            // btnPersonel
            // 
            this.btnPersonel.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnPersonel.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnPersonel.Location = new System.Drawing.Point(20, 343);
            this.btnPersonel.Margin = new System.Windows.Forms.Padding(4);
            this.btnPersonel.Name = "btnPersonel";
            this.btnPersonel.Size = new System.Drawing.Size(228, 55);
            this.btnPersonel.TabIndex = 13;
            this.btnPersonel.Text = "Personel Bilgileri";
            this.btnPersonel.UseVisualStyleBackColor = false;
            this.btnPersonel.Click += new System.EventHandler(this.btnPersonel_Click);
            // 
            // lblBBaslik
            // 
            this.lblBBaslik.AutoSize = true;
            this.lblBBaslik.Font = new System.Drawing.Font("Consolas", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.lblBBaslik.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblBBaslik.Location = new System.Drawing.Point(286, 14);
            this.lblBBaslik.Name = "lblBBaslik";
            this.lblBBaslik.Size = new System.Drawing.Size(383, 36);
            this.lblBBaslik.TabIndex = 36;
            this.lblBBaslik.Text = "Otel/Yönetici Bilgileri";
            // 
            // btnYoneticiAra
            // 
            this.btnYoneticiAra.BackColor = System.Drawing.Color.AliceBlue;
            this.btnYoneticiAra.Font = new System.Drawing.Font("Consolas", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.btnYoneticiAra.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.btnYoneticiAra.Location = new System.Drawing.Point(848, 572);
            this.btnYoneticiAra.Margin = new System.Windows.Forms.Padding(4);
            this.btnYoneticiAra.Name = "btnYoneticiAra";
            this.btnYoneticiAra.Size = new System.Drawing.Size(180, 39);
            this.btnYoneticiAra.TabIndex = 108;
            this.btnYoneticiAra.Text = "Yönetici Ara";
            this.btnYoneticiAra.UseVisualStyleBackColor = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label3.Location = new System.Drawing.Point(26, 458);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(175, 23);
            this.label3.TabIndex = 107;
            this.label3.Text = "Aranan Yönetici";
            // 
            // dataGridView3
            // 
            this.dataGridView3.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView3.BackgroundColor = System.Drawing.SystemColors.Control;
            this.dataGridView3.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView3.Location = new System.Drawing.Point(20, 484);
            this.dataGridView3.Name = "dataGridView3";
            this.dataGridView3.RowHeadersWidth = 51;
            this.dataGridView3.RowTemplate.Height = 24;
            this.dataGridView3.Size = new System.Drawing.Size(696, 94);
            this.dataGridView3.TabIndex = 106;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(956, 514);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(172, 34);
            this.textBox1.TabIndex = 105;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label4.Location = new System.Drawing.Point(742, 525);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(208, 23);
            this.label4.TabIndex = 104;
            this.label4.Text = "Yönetici Numarası:";
            // 
            // OtelYoneticiForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(11F, 23F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.LightSteelBlue;
            this.ClientSize = new System.Drawing.Size(1397, 724);
            this.Controls.Add(this.lblBBaslik);
            this.Controls.Add(this.btnPersonel);
            this.Controls.Add(this.btnMusteri);
            this.Controls.Add(this.btnOdaRezervasyon);
            this.Controls.Add(this.btnOtelYonetici);
            this.Controls.Add(this.Panel);
            this.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.Name = "OtelYoneticiForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Postgre Otel";
            this.Load += new System.EventHandler(this.OtelYoneticiForm_Load);
            this.Panel.ResumeLayout(false);
            this.Panel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView3)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel Panel;
        private System.Windows.Forms.Button btnMusteri;
        private System.Windows.Forms.Button btnOdaRezervasyon;
        private System.Windows.Forms.Button btnOtelYonetici;
        private System.Windows.Forms.Button btnPersonel;
        private System.Windows.Forms.Label lblBBaslik;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dataGridView2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button btnKaydetOda;
        private System.Windows.Forms.TextBox txtyoneticiNum;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button btnYoneticiAra;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.DataGridView dataGridView3;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label4;
    }
}

